# RAGStack AI

> Production-style RAG chatbot with FastAPI, LangGraph, Next.js, authentication, memory, streaming responses, PostgreSQL/pgvector, Redis, Prometheus and Grafana.

## Overview

RAGStack AI is a full-stack Retrieval-Augmented Generation application designed like an enterprise AI system, not a notebook demo.

It combines a FastAPI backend, LangGraph-based RAG workflow, PostgreSQL/pgvector vector search, Redis caching, JWT authentication, session-based chat, streaming responses, and observability through Prometheus and Grafana.

The goal of this project is to demonstrate how production-grade AI applications can be structured with clean backend architecture, persistent user sessions, traceable conversations, containerized services, and operational monitoring.

## Key Features

- JWT-based user authentication
- Session-based chat workflow
- LangGraph-powered RAG pipeline
- PostgreSQL with pgvector for vector search
- Redis/Valkey for caching and runtime support
- Streaming responses using Server-Sent Events
- Conversation persistence
- Long-term memory support
- Prometheus metrics endpoint
- Grafana dashboards
- Docker Compose deployment
- Next.js frontend for login and chat

## Tech Stack

| Layer | Stack |
|---|---|
| Backend | FastAPI, Python |
| Agent Workflow | LangGraph, LangChain |
| Frontend | Next.js, TypeScript |
| Database | PostgreSQL, pgvector |
| Cache | Redis / Valkey |
| Auth | JWT |
| Observability | Prometheus, Grafana |
| DevOps | Docker, Docker Compose |

## Architecture

```text
Next.js Frontend
      │
      ▼
FastAPI Backend ───────▶ PostgreSQL + pgvector
      │                         │
      ▼                         ▼
LangGraph RAG Workflow      Chat Sessions
      │
      ├── Retrieve context
      ├── Load memory
      ├── Generate response
      ├── Stream answer
      └── Persist conversation

Prometheus ───────▶ Grafana
```

## RAG

User Question
   ↓
Validate Request
   ↓
Load Chat Session
   ↓
Retrieve Relevant Context
   ↓
Inject Memory
   ↓
Generate Answer
   ↓
Stream Response
   ↓
Save Conversation
