'# Troubleshooting – Dificuldades e Soluções Durante o Laboratório SOC

Este documento reúne os principais problemas encontrados durante a construção do laboratório de SOC (Security Operations Center) e as soluções adotadas para resolvê-los.

A ideia aqui não é apenas mostrar o que funcionou, mas também registrar os erros, tentativas e pequenas descobertas que aconteceram durante o processo. Muitos desses problemas parecem simples, mas consumiram bastante tempo e foram importantes para entender melhor o funcionamento do ambiente.

---

# 1. Layout do teclado incorreto na VM

## Problema

Durante o uso do Ubuntu Server dentro da máquina virtual, o teclado não correspondia ao layout configurado.

Mesmo selecionando **Português** e a variante correta durante a instalação, algumas teclas ainda digitavam caracteres diferentes do esperado.

Isso dificultava bastante executar comandos no terminal, principalmente porque alguns símbolos importantes para Linux simplesmente não apareciam corretamente.

## Solução

Explorando as opções do sistema, encontrei uma opção chamada algo parecido com:

> **"Detect Keyboard Layout" / "Find your keyboard layout"**

Esse modo executa um pequeno teste onde o sistema pede para pressionar algumas teclas específicas.

Após fazer esse teste, o Ubuntu conseguiu detectar corretamente o layout do teclado.

Depois disso o problema desapareceu completamente.

## Recomendação

Mesmo que o layout já esteja configurado corretamente, vale a pena rodar o **detector automático de teclado**, principalmente em ambientes virtualizados.

---

# 2. Esquecer usuário e senha após instalar o sistema

## Problema

Depois de instalar o Ubuntu Server na VM, aconteceu algo bem simples mas que acabou virando um pequeno problema:

Eu **esqueci o nome do usuário e a senha que havia criado durante a instalação**.

Como o sistema estava recém instalado, isso impediu o login normal.

## Solução

Para resolver isso, entrei no modo de recuperação do Ubuntu.

Durante o boot da máquina virtual:

1. Acessei o menu de boot do Ubuntu
2. Entrei no **modo recovery**
3. Acessei um terminal com permissões de root

Depois disso, comecei a explorar o sistema para identificar os usuários existentes.

Um comando simples ajudou bastante:

```bash
ls /home
```

Isso mostrou quais usuários estavam criados no sistema.

A partir disso foi possível identificar o nome do usuário e fazer os ajustes necessários.

## Aprendizado

Mesmo em laboratórios simples, é importante **anotar credenciais básicas durante a instalação do sistema**.

Isso teria evitado alguns minutos de investigação.

---

# 3. Instalação extremamente lenta das ferramentas SIEM

## Problema

Durante a instalação das ferramentas do ambiente SIEM, principalmente:

* Elasticsearch
* Kibana
* Filebeat

o processo estava demorando **muitas horas**.

Mesmo tentando melhorar a configuração de rede da VM (modo bridge e outros ajustes), os downloads ainda eram muito lentos.

Isso acabou atrasando bastante o progresso do laboratório.

## Solução

Foi nesse momento que uma ferramenta acabou salvando bastante tempo: **SSH**.

Configurei acesso SSH ao servidor Ubuntu e comecei a administrar o sistema diretamente do **PowerShell no computador host**.

Isso já melhorou muito a produtividade, porque o teclado e o terminal do host são muito mais rápidos de usar do que o console da VM.

Mas o grande ganho veio com o comando **SCP**.

### Uso do SCP

O `scp` permite copiar arquivos diretamente de um computador para outro usando SSH.

Então a estratégia foi:

1. Baixar os pacotes no computador principal (host)
2. Transferir os arquivos diretamente para a VM

Exemplo:

```bash
scp pacote.deb usuario@ip_da_vm:/home/usuario
```

Depois disso, a instalação foi feita localmente dentro da VM usando:

```bash
sudo dpkg -i pacote.deb
```

## Resultado

O que antes estava demorando **horas para baixar**, passou a levar **menos de dois minutos**.

Isso acelerou muito o processo de configuração do laboratório.

## Aprendizado

Transferir arquivos localmente com `scp` pode ser muito mais eficiente do que depender do download direto dentro da VM.

---
late of mix in all file possible of network and make a gambiarras how create a file 99-cloud-init.yaml... for the SO scan he first than 50-cloud-init.yaml... like this my change stayed in the vm same that i shout down kkkk.

however you dont need make it, because i find a solution 110% better 

Tip of gold: setting a vm for mode NAT, but why? if i put it don't gonna can acess SSH, calm down half that it is correct you no go, but have a solution or a macetizinho, you need redimesion a port direct for a vm, but how make it? simple i show a print.
With you can doawold of pacth and fille more speed.

Depend of your internet too. I make the test with card-network in mode bridge and nat.
tool use was speed test

results down:

mode Bridge = 5,34 mbit/s if you make the division it's 5,34/8 = 0,6 bytes/s very slow i think that a internet discard was better 

mode Nat = 94,12 mbits/s almost 20x more speed 11,7 bytes/s.

my better tip was that.

# 4. Uso de SSH para facilitar a administração

## Problema

No início eu estava controlando tudo diretamente pelo terminal da máquina virtual.

Isso era bastante desconfortável porque:

* O teclado estava com problemas
* Copiar comandos era difícil
* A interface da VM é limitada

## Solução

Configurei acesso **SSH** no servidor Ubuntu.

Depois disso passei a acessar a VM diretamente pelo **PowerShell do Windows**.

Exemplo de conexão:

```bash
ssh usuario@ip_da_vm
```

## Resultado

A produtividade aumentou muito.

Foi possível:

* Copiar e colar comandos facilmente
* Transferir arquivos
* Trabalhar com terminal mais rápido

Na prática isso facilitou cerca de **1000x o gerenciamento do servidor**.

---
# 5. Automation of maneger (start/status/stop)

it here was very use of more 5 year life for my keyboard, and too increase the efficiency in 10x because i dont need more write 
all the comand was just run the script kkkkk you sensitive a donkey for no have use before kkkkk

# 6. Limitação de memória para o Elasticsearch

## Problema

A máquina virtual utilizada no laboratório possui aproximadamente **3.2GB de RAM**.

O Elasticsearch, por padrão, pode consumir bastante memória.

Sem ajustes, o sistema ficava pesado e existia risco de travamentos.

Além disso, inicialmente não encontrei um arquivo de configuração de memória claro para ajustar esse comportamento.

## Solução

A solução foi criar manualmente um arquivo de configuração dentro do diretório de opções da JVM.

Arquivo criado:

```
jvm.options.d/memory.options
```

Conteúdo do arquivo:

```
-Xms512m
-Xmx512m
```

### Explicação

* `-Xms` define a memória inicial da JVM
* `-Xmx` define o limite máximo de memória

Nesse caso limitei o Elasticsearch a **512MB de RAM**.

## Resultado

Com essa limitação o sistema ficou muito mais estável e adequado para o laboratório com recursos limitados.

---

# 7. Otimização geral do ambiente devido à pouca RAM

## Problema

Como o ambiente possui recursos limitados (principalmente memória), várias ferramentas precisaram ser configuradas manualmente para consumir menos recursos.

Isso incluiu ajustes em:

* Elasticsearch
* Kibana
* outros serviços do ambiente SIEM

Muitos desses ajustes foram feitos manualmente editando arquivos de configuração com o editor `nano`.

## Solução

Foram aplicadas configurações mínimas de funcionamento para cada ferramenta, priorizando estabilidade em vez de desempenho.

Além disso, scripts estão sendo criados para facilitar a inicialização dos serviços sem precisar digitar todos os comandos manualmente.

---

# Conclusão

Grande parte dos desafios encontrados neste laboratório não estavam diretamente documentados em guias simples.

Isso exigiu bastante tentativa e erro, pesquisa e adaptação das configurações para que o ambiente funcionasse dentro das limitações de hardware disponíveis.

Apesar das dificuldades, esse processo acabou sendo extremamente útil para entender melhor como cada componente do ambiente funciona e como resolver problemas práticos que aparecem em sistemas reais.

The tip max plus ultra power x prime, for all that you begin, maaaaaaakkkkeeeee the documention of all kkkkkk 

However is much important you digit command and understend what he making. 
