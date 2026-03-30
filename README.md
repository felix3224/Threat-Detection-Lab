
# 🛡️ Network Sentinel Lab – SOC Stack para Análise de Tráfego e Monitoramento de Rede

<div align="center">

![Status](https://img.shields.io/badge/status-active-success.svg)
[![Elastic Stack](https://img.shields.io/badge/Elastic%20Stack-7.17-005571?logo=elastic)](https://www.elastic.co/)
[![Zeek](https://img.shields.io/badge/Zeek-6.0-4C9F70?logo=zeek)](https://zeek.org/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-E95420?logo=ubuntu)](https://ubuntu.com/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

</div>

---

## 📌 Visão Geral

**Network Sentinel Lab** é um ambiente de laboratório profissional para detecção de ameaças, centralização de logs e monitoramento de tráfego em tempo real.  
Desenvolvido com foco em **baixo consumo de recursos**, permite a execução de um SOC (Security Operations Center) funcional em uma máquina virtual com **apenas 3.2GB de RAM**.

O projeto combina a stack Elastic (Elasticsearch + Kibana + Filebeat) com o **Zeek 6.0**, um poderoso framework de análise de tráfego de rede, demonstrando habilidades de **detecção de intrusão, ingestão de logs, automação via CLI e otimização de sistemas Linux para ambientes restritos**.

---

## 🏗️ Arquitetura do Projeto

<img src=".\assets\image.png" alt="arquiterura" width="900px" height="500px">
```

---

## ⚙️ Tecnologias Utilizadas

| Camada                | Tecnologia          | Versão   | Função                                  |
|-----------------------|---------------------|---------|------------------------------------------|
| **SIEM / Logging**    | Elasticsearch       | 7.17.23 | Armazenamento e indexação de logs       |
|                       | Kibana              | 7.17.23 | Visualização e dashboards               |
|                       | Filebeat            | 7.17.23 | Coleta e envio de logs                  |
| **IDS / NTA**         | Zeek                | 6.0     | Análise de tráfego e detecção de scans  |
| **Alvo Vulnerável**   | Apache2 + PHP       | 2.4.52  | Servidor web com aplicação vulnerável   |
|                       | MySQL               | 8.0     | Banco de dados com credenciais fracas   |
| **Infraestrutura**    | Ubuntu Server       | 22.04   | Sistema operacional da VM               |
|                       | VirtualBox          | 7.2.6   | Virtualização e isolamento              |
| **Automação**         | Bash Scripting      | -       | Scripts de start/stop/status            |

---

## 🚀 Instalação Rápida

### 1️⃣ Pré-requisitos

- VirtualBox instalado no host Windows
- ISO do Ubuntu Server 22.04
- Acesso à internet para download de pacotes

### 2️⃣ Configuração da Rede (Bridge)

Configure a VM em modo **Bridge** para que ela receba um IP na mesma faixa do seu host:

```bash
# Verifique o IP após iniciar a VM
ip a | grep inet
```

### 3️⃣ Instalação dos Componentes

```bash
# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Elastic Stack
sudo dpkg -i elasticsearch-7.17.23-amd64.deb
sudo dpkg -i kibana-7.17.23-amd64.deb
sudo dpkg -i filebeat-7.17.23-amd64.deb

# Instalar Zeek 6.0
cd /tmp
wget https://github.com/zeek/zeek/archive/v6.0.0.tar.gz
tar xzf v6.0.0.tar.gz
cd zeek-6.0.0
./configure --prefix=/usr/local/zeek
make
sudo make install

# Adicionar ao PATH
echo 'export PATH=/usr/local/zeek/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

### 4️⃣ Inicialização dos Serviços

```bash
# Iniciar Elastic Stack
sudo systemctl start elasticsearch
sudo systemctl start kibana
sudo systemctl start filebeat

# Iniciar Zeek
sudo zeekctl deploy

# Verificar status
./status.sh
```

---

## 📁 Arquivos de Configuração Principais

| Arquivo                         | Descrição                                                                 |
|---------------------------------|---------------------------------------------------------------------------|
| `/etc/elasticsearch/elasticsearch.yml` | Configuração do Elasticsearch (single-node, desabilita security)   |
| `/etc/elasticsearch/jvm.options`       | Limitação de memória para `-Xms512m -Xmx512m`                      |
| `/etc/kibana/kibana.yml`               | Libera acesso externo com `server.host: "0.0.0.0"`                 |
| `/etc/filebeat/filebeat.yml`           | Ingestão de logs do Apache, sistema e Zeek                         |
| `/opt/zeek/etc/node.cfg`               | Interface de rede monitorada pelo Zeek                             |
| `/etc/mysql/mysql.conf.d/mysqld.cnf`   | Otimização do MySQL para baixa memória                             |

---
## 🎯 MITRE ATT&CK Framework – Mapeamento de Ameaças

O laboratório foi projetado para simular e detectar técnicas reais de atacantes, alinhadas ao **MITRE ATT&CK**, o padrão global para descrição de comportamentos adversários.

| Tática | Técnica | ID | Implementação no Lab | Detecção |
|--------|---------|-----|----------------------|----------|
| **Reconnaissance** | Active Scanning | T1595 | `nmap -sS` contra a VM | Zeek – `conn.log` / `scan.log` |
| **Initial Access** | Exploit Public-Facing Application | T1190 | SQL Injection no `check.php` | Logs de ataque em `attacks.log` |
| **Execution** | Command and Scripting Interpreter | T1059 | Comandos `curl` e SQLi manuais | Logs do Apache (`access.log`) |
| **Credential Access** | Brute Force | T1110 | `hydra` contra formulário de login | `login_attempts.log` com múltiplas tentativas |
| **Discovery** | Network Service Scanning | T1046 | `nmap -sV` para descoberta de portas | Zeek – `conn.log` com conexões suspeitas |

---

## 🧪 OWASP Top 10 – Vulnerabilidades Implementadas

O site vulnerável foi desenvolvido propositalmente com falhas de segurança para demonstrar as principais ameaças de aplicações web, conforme o **OWASP Top 10 (2021)** .

| ID | Vulnerabilidade | Local no Lab | Como Testar |
|----|-----------------|--------------|-------------|
| **A03:2021** | Injection (SQL) | `check.php`, `users.php`, `search.php` | Payload: `' OR '1'='1' --` |
| **A01:2021** | Broken Access Control | `users.php?id=1` | Manipular parâmetro `id` para acessar dados indevidos |
| **A05:2021** | Security Misconfiguration | MySQL root sem senha, debug ativo | `sudo mysql` sem autenticação |
| **A04:2021** | Insecure Design | Site inteiro | Estrutura propositalmente vulnerável a ataques |
| **A06:2021** | Vulnerable and Outdated Components | PHP/MySQL em versões LTS (controladas) | Versões utilizadas não possuem patches de segurança avançados |

## 🔧 Troubleshooting & Otimização

### 🔹 Kibana: Acesso Externo

**Problema:** Kibana não responde pelo navegador do host.

**Solução:** Configure o Kibana para escutar em todas as interfaces:

```yml
# /etc/kibana/kibana.yml
server.host: "0.0.0.0"
server.port: 5601
```

Após alterar, reinicie o serviço:

```bash
sudo systemctl restart kibana
```

Agora acesse: `http://192.168.1.150:5601`

---

---

## 📊 Funcionalidades Implementadas

| Funcionalidade                     | Descrição                                                                 |
|------------------------------------|---------------------------------------------------------------------------|
| ✅ **Centralização de Logs**       | Elasticsearch recebe logs do Apache, sistema e Zeek via Filebeat          |
| ✅ **Visualização em Tempo Real**  | Kibana com dashboards customizáveis e buscas avançadas                    |
| ✅ **Detecção de Scans**           | Zeek identifica varreduras de porta (nmap) e registra em `conn.log`       |
| ✅ **Detecção de Força Bruta**     | Hydra contra site vulnerável gera logs no `login_attempts.log`            |
| ✅ **Detecção de SQL Injection**   | Payloads maliciosos são registrados em `attacks.log`                      |
| ✅ **Automação via Bash**          | Scripts `start-all.sh`, `stop-all.sh` e `status.sh` para gestão completa  |
| ✅ **Baixo Consumo**               | Ambiente otimizado para rodar com 3.2GB RAM                               |

---

## 🛠️ Comandos de Operação

```bash
# Iniciar todos os serviços
./start-all.sh

# Verificar status do ambiente
./status.sh

# Parar todos os serviços
./stop-all.sh

# Monitorar tentativas de login em tempo real
tail -f /var/www/html/lab_site/logs/login_attempts.log

# Monitorar conexões detectadas pelo Zeek
sudo tail -f /opt/zeek/logs/current/conn.log
```

---

## 📊 Dashboards e Buscas no Kibana

### Data View
- **Nome:** `filebeat`
- **Pattern:** `filebeat-*`
- **Time Field:** `@timestamp`

### Buscas Úteis

| Objetivo                              | Query                               |
|---------------------------------------|-------------------------------------|
| Ver todos os logs do site vulnerável  | `log_type: lab_site`                |
| Ver tentativas de SQL Injection       | `"SQL Injection"`                   |
| Ver logs do Zeek                      | `log_type: zeek`                    |
| Filtrar por IP do atacante            | `source.ip: "192.168.1.xxx"`        |
| Tentativas com usuário admin          | `usuario: "admin"`                  |

---

## 📸 Evidências e Capturas de Tela

> *Os prints abaixo demonstram o ambiente em funcionamento.*

### Kibana – Logs de SQL Injection
![Kibana SQL Injection](screenshots/kibana-sqli.png)

### Zeek – Detecção de Scan
![Zeek Scan Detection](screenshots/zeek-scan.png)

### Ataque Hydra no Terminal
![Hydra Attack](screenshots/hydra-attack.png)

### Dashboard do Kibana
![Kibana Dashboard](screenshots/kibana-dashboard.png)

---

## 📂 Estrutura do Repositório

```
soc-lab/
├── README.md                    # Documentação principal
├── docs/
│   ├── documentation.md         # Documentação técnica completa
│   └── troubleshooting.md       # Guia de resolução de problemas
├── config/
│   ├── elasticsearch.yml
│   ├── kibana.yml
│   ├── filebeat.yml
│   ├── node.cfg
│   └── mysqld.cnf
├── scripts/
│   ├── start-security.sh
│   ├── stop-all.sh
|   ├──start-target.sh
│   └── status.sh
├── screenshots/
│   ├── kibana-sqli.png
│   ├── zeek-scan.png
│   ├── hydra-attack.png
│   └── kibana-dashboard.png
└── logs/
    ├── login_attempts.log.sample
    └── attacks.log.sample
```

---

## 🧠 Lições Aprendidas e Otimizações

1. **Zeek em VMs com pouca RAM:**  
   Desativar checksums e protocolos não essenciais reduziu o consumo de memória em ~30%.

2. **Kibana com acesso externo:**  
   A configuração `server.host: "0.0.0.0"` é essencial para acessar o dashboard fora da VM.

3. **Filebeat e permissões de log:**  
   Ajustar permissões com `chmod 666` garantiu que o Filebeat lesse os logs do site vulnerável.

4. **Automação com Bash:**  
   Scripts reduziram o tempo de setup de minutos para segundos.

---

## 🔗 Referências e Recursos

| Recurso | Link |
|---------|------|
| Elastic Stack Documentation | [https://www.elastic.co/guide/](https://www.elastic.co/guide/) |
| Zeek User Manual | [https://docs.zeek.org/](https://docs.zeek.org/) |
| MITRE ATT&CK Framework | [https://attack.mitre.org/](https://attack.mitre.org/) |
| OWASP Top 10 | [https://owasp.org/Top10/](https://owasp.org/Top10/) |
| TryHackMe – Intro to SIEM | [https://tryhackme.com/room/introtosiem](https://tryhackme.com/room/introtosiem) |

---

## 📄 Licença

Este projeto está licenciado sob a licença MIT – veja o arquivo [LICENSE](LICENSE) para detalhes.

---

## 👨‍💻 Autor

**Davi Witalo Félix da Silva**  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?logo=linkedin&logoColor=white)](https://www.linkedin.com/in/witalo-f%C3%A9lix-65566b384/)
[![GitHub](https://img.shields.io/badge/GitHub-181717?logo=github&logoColor=white)](https://github.com/felix3224)

---

```
