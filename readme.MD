### IMPETUS Educational Chatbot Project

The **IMPETUS** project focuses on developing specialized chatbots for educational purposes, analyzing student-bot interactions to optimize learning experiences. The initiative leverages **LangChain** for chatbot prototyping and **Flowise** for workflow management, with emphasis on secure deployment, database integration, and access control.

---

### Project Overview
**Primary Goal**: Investigate optimization strategies for educational chatbots and identify effective prompting techniques to maximize student engagement.  
**Focus Areas**:
- Interaction analytics via custom database logging
- Secure deployment architecture for chatbot interfaces
- Migration from SQLite to PostgreSQL for long-term scalability
- Access control separation between admin/student interfaces

**Core Technologies**:
- **LangChain**: Python-based framework for LLM pipeline construction ([Documentation](https://python.langchain.com/docs/tutorials/))
- **Flowise**: Drag-and-drop UI for chatbot workflows ([GitHub Integration Example](https://github.com/AXRoux/Flowise-LangChain))
- **Docker**: Containerization for service isolation and deployment reproducibility

**Project Repositories**:  
[https://transfer.hft-stuttgart.de/gitlab/22baar1mst/flowise-ollama](https://transfer.hft-stuttgart.de/gitlab/22baar1mst/flowise-ollama)

[https://github.com/ArtemBaranovsky/flowise-ollama](https://github.com/ArtemBaranovsky/flowise-ollama) (mirror)

### Key Objectives
1. **Global Service Installation**:
    - Dockerize Flowise/LangChain for system-wide availability
    - Separate student-facing chat interface (port 3000) from admin panel

2. **Database Migration**:
    - Replace SQLite with PostgreSQL for production-grade reliability
    - Implement volume persistence for critical data

3. **Security Hardening**:
    - Isolate administrative endpoints via Nginx routing
    - Implement Basic Auth with fallback to JWT/OAuth2

4. **LLM Infrastructure**:
    - Integrate Ollama for local model management
    - Configure RAG (Retrieval-Augmented Generation) workflows

---

### Implementation Highlights

#### 1. Dockerized Architecture
```yaml  
# docker-compose.yml (simplified)  
services:  
  flowise:  
    image: flowiseai/flowise:latest  
    ports: ["3000:3000"]  
    depends_on: [postgres, ollama]  

  postgres:  
    image: postgres:16-alpine  
    volumes: ["./pgdata:/var/lib/postgresql/data"]  

  ollama:  
    build: ./ollama-models  
    ports: ["11435:11434"]  

  nginx:  
    image: nginx:alpine  
    ports: ["8080:80"]  
    configs: ["./nginx/:/etc/nginx/"]  
```  

#### 2. Access Control Implementation
```nginx  
# nginx.conf (security routing)  
location /admin/ {  
  auth_basic "Restricted Area";  
  auth_basic_user_file /etc/nginx/.htpasswd;  
  proxy_pass http://flowise:3000/api/v1/;  
}  

location /chat/ {  
  proxy_pass http://flowise:3000/;  
}  
```  

#### 3. Ollama Model Integration
```Dockerfile  
# Custom Ollama Dockerfile  
FROM ollama/ollama  
RUN ollama pull ${MODEL_NAME}  
CMD ["ollama", "serve"]  
```  

---

### Challenges & Solutions

| Challenge | Resolution |  
|-----------|------------|  
| **Flowise Admin/Chat Interface Collision** | Implemented Nginx path-based routing with Basic Auth |  
| **SQLite Scalability Limitations** | Migrated to PostgreSQL with automated schema migration |  
| **Model Loading Failures** | Created pre-loading script for Ollama containers |  
| **Student Access Exploits** | Added IP filtering + rate limiting in Nginx |  

Stable implemented version of this simple solution is at https://transfer.hft-stuttgart.de/gitlab/22baar1mst/flowise-ollama/-/commit/5c4d44705f550546423afcd06bc7e69a54e4276a


**Unresolved Issues**:
- Basic Auth bypass vulnerabilities in shared port configuration
- LangChain migration incomplete due to time constraints

---

### Deployment Workflow

1. **Infrastructure Setup**:
```bash  
ssh impetus@193.196.53.83 -i <key.pem>  
docker-compose up -d --build  
```  

2. **Environment Configuration**:
```.env  
DATABASE_URL=postgresql://user:pass@postgres:5432/db  
OLLAMA_MODEL=llama2-uncensored  
NGINX_PORT=8080  
```  

3. **Security Hardening**:
```bash  
# Generate admin credentials  
htpasswd -c ./nginx/.htpasswd admin  
```  

---

### Future Development Plan

1. **LangChain Migration**:
    - Port Flowise workflows to LangChain agents
    - Implement dual interface system:
        - `/chat` – student-facing endpoint
        - `/admin` – JWT-protected management UI

2. **Enhanced Security**:
    - Implement OAuth2 via Keycloak/Linkding
    - Add audit logging for all admin actions

3. **CI/CD Pipeline**:
    - Automated Docker builds on GitLab
    - Canary deployment strategy

4. **Analytics Integration**:
    - ClickHouse for interaction telemetry
    - Grafana dashboard for usage metrics

---

### Conclusion
The IMPETUS project demonstrates a viable architecture for educational chatbots using Dockerized LLM components. While Flowise provided rapid prototyping capabilities, future work will focus on transitioning to LangChain for greater flexibility. The current implementation achieves:
- Isolated PostgreSQL database with persistent storage
- Basic access control through Nginx
- Local LLM management via Ollama

**Next Steps**: Address security vulnerabilities in access control and complete LangChain migration using [Flowise-LangChain integration templates](https://volcano-ice-cd6.notion.site/Introduction-to-Practical-Building-LLM-Applications-with-Flowise-LangChain-03d6d75bfd20495d96dfdae964bea5a5).

---

(Due to technical issues, the search service is temporarily unavailable.)

### Deployment Guide: Flowise-Ollama Chatbot System

#### Prerequisites
1. **Docker** and **Docker Compose** installed
2. **Hugging Face Account** (for accessing LLM models)
3. Minimum **8GB RAM** and **20GB Disk Space**

---

### Step-by-Step Deployment

#### 1. Clone Repository
```bash  
git clone https://transfer.hft-stuttgart.de/gitlab/22baar1mst/flowise-ollama.git  
cd flowise-ollama  
```  

#### 2. Configure Environment
Create `.env` file or copy from .env.Example:
```ini  
# Database  
DATABASE_NAME=flowise  
DATABASE_USER=admin  
DATABASE_PASSWORD=SecurePass123!  
DATABASE_TYPE=postgres  
DATABASE_PORT=5432  

# Flowise  
PORT=3000  
FLOWISE_USERNAME=admin  
FLOWISE_PASSWORD=AdminSecure456!  

# Ollama  
HF_TOKEN=your_huggingface_token  
GIN_MODE=release  
```  

Don't forget to register and use credentials for
HF_TOKEN=
LANGCHAIN_API_KEY=


#### 3. Start Services
```bash  
docker-compose up -d --build  
```  
*This will:*
- Launch PostgreSQL database with persistent storage
- Start Flowise with Ollama integration
- Automatically load specified LLM models

#### 4. Verify Services
```bash  
docker ps -a  
```  
Expected output:
```  
CONTAINER ID   IMAGE                      STATUS                   PORTS  
a1b2c3d4e5f6   flowiseai/flowise:latest   Up 5 minutes (healthy)   0.0.0.0:3000->3000/tcp  
g7h8i9j0k1l2   postgres:16-alpine         Up 5 minutes (healthy)   5432/tcp  
m3n4o5p6q7r8   ollama                     Up 5 minutes            0.0.0.0:11434->11434/tcp  
```  

#### 5. Access Flowise UI
1. Open `http://localhost:3000` in browser
2. Log in using credentials from `.env`:
    - **Username**: `admin`
    - **Password**: `AdminSecure456!`

#### 6. Import Chatflow
1. Navigate to **Chatflows** → **Add New**
2. Import `Ollama_RAG_Chatflow.json` (drag-and-drop or use file picker)
3. Configure RAG parameters:
   ```json  
   {  
     "model": "llama2-uncensored",  
     "temperature": 0.7,  
     "max_tokens": 500  
   }  
   ```  

#### 7. Test Ollama Integration
```bash  
curl http://localhost:11434/api/tags  
```  
Expected response:
```json  
{"models":[{"name":"llama2-uncensored","modified_at":"2024-03-15T12:34:56.789Z"}]}  
```  

---

### Key Endpoints
| Service | URL | Port |  
|---------|-----|------|  
| Flowise UI | `http://<server-ip>:3000` | 3000 |  
| Ollama API | `http://<server-ip>:11434` | 11434 |  
| PostgreSQL | `postgres://admin:SecurePass123!@localhost:5432/flowise` | 5432 |  

---

### Troubleshooting
1. **Healthcheck Failures**:
   ```bash  
   docker logs flowiseai --tail 50  
   docker exec -it flowise-db psql -U admin -d flowise  
   ```  

2. **Model Loading Issues**:
   ```bash  
   docker exec ollama ollama list  
   docker exec ollama ollama pull llama2-uncensored  
   ```  

3. **Port Conflicts**:  
   Update `PORT` in `.env` and restart:
   ```bash  
   docker-compose down && docker-compose up -d  
   ```  

---

### Security Recommendations
1. Add Nginx reverse proxy with SSL
2. Implement IP whitelisting for `/api/v1` endpoints
3. Rotate database credentials monthly
4. Monitor Ollama GPU utilization:
   ```bash  
   docker stats ollama  
   ```  

This deployment provides a fully functional educational chatbot system with RAG capabilities. For advanced configuration, refer to [Flowise-Ollama Integration Guide](https://github.com/ArtemBaranovsky/flowise-ollama).