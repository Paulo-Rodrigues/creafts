# 🧪 Crafts - Laboratório de Microserviços

> Um projeto agnóstico ao domínio para experimentação de técnicas, padrões e tecnologias modernas.

## 📋 Sobre o Projeto

Este é um laboratório experimental focado no desenvolvimento e teste de diferentes técnicas de arquitetura de software, microserviços e tecnologias. O projeto é **agnóstico ao domínio**, ou seja, não possui um objetivo de negócio específico - sua finalidade é puramente educativa e experimental.

## 🏗️ Arquitetura

### Microserviços

- **`auth_api/`** - Serviço de autenticação e autorização
  - Ruby on Rails (API-only)
  - JWT Token Authentication
  - Docker containerizado

- **`webapp/`** - Interface web moderna
  - Next.js 15 com TypeScript
  - shadcn/ui + Tailwind CSS
  - React Hook Form + Zod

### Stack Tecnológica

#### Backend (auth_api)
- **Ruby on Rails** - Framework web
- **SQLite** - Banco de dados (desenvolvimento)
- **JWT** - Autenticação stateless
- **Docker** - Containerização
- **RSpec** - Testes unitários

#### Frontend (webapp)
- **Next.js 15** - Framework React
- **TypeScript** - Type safety
- **shadcn/ui** - Componentes UI modernos
- **Tailwind CSS** - Styling
- **React Hook Form** - Gerenciamento de formulários
- **Zod** - Validação de schemas

#### DevOps & Ferramentas
- **Docker Compose** - Orquestração local
- **Kamal** - Deploy simplificado

## 🚀 Como Executar

### Pré-requisitos
- Docker & Docker Compose
- Node.js 18+ (para desenvolvimento frontend)
- Ruby 3.1+ (para desenvolvimento backend)

### Execução com Docker
```bash
# Clone o repositório
git clone <repo-url>
cd crafts

# Execute todos os serviços
docker-compose up -d

# Acesse os serviços
# Frontend: http://localhost:3000
# Auth API: http://localhost:3001
```

### Desenvolvimento Local

#### Backend (auth_api)
```bash
cd auth_api
bundle install
rails db:setup
rails server -p 3001
```

#### Frontend (webapp)
```bash
cd webapp
npm install
npm run dev
```

## 🧩 Funcionalidades Implementadas

### ✅ Autenticação
- [x] Sistema de login com JWT
- [x] Gerenciamento automático de tokens
- [x] Validação de formulários
- [x] Estados de loading e erro

### ✅ API Client
- [x] Cliente HTTP flexível
- [x] Interceptadores automáticos
- [x] Tratamento de erros
- [x] Suporte a query params e headers customizados

### ✅ Interface Moderna
- [x] Componentes reutilizáveis (shadcn/ui)
- [x] Formulários validados (React Hook Form + Zod)
- [x] Design responsivo
- [x] Type safety completo


## 🎯 Objetivos de Aprendizado

1. **Microserviços**: Comunicação, isolamento, deploy independente
2. **Padrões de Resilência**: Circuit breakers, retry, timeout
3. **Event-Driven Architecture**: Pub/Sub, Event Sourcing
4. **DevOps**: CI/CD, Monitoring, Logging
5. **Security**: OAuth2, RBAC, API Security
6. **Performance**: Caching, CDN, Otimizações

---

**💡 Lembrete**: Este é um laboratório de experimentos. O código pode mudar drasticamente conforme novos padrões e técnicas são explorados.