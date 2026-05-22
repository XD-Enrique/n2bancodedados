-- Ativar extensão para geração de UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. IDENTIDADE E PERFIS
CREATE TABLE auth_users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Perfil vinculado 1:1 à autenticação
CREATE TABLE perfis (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    auth_user_id UUID NOT NULL UNIQUE REFERENCES auth_users(id) ON DELETE CASCADE,
    nome_completo VARCHAR(255) NOT NULL,
    papel VARCHAR(50) DEFAULT 'aluno' CHECK (papel IN ('aluno', 'admin_escolar', 'admin_global')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. ESTRUTURA ESCOLAR E MATRÍCULAS
CREATE TABLE escolas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome VARCHAR(255) NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL, -- impede CNPJ duplicado
    gestor_id UUID NOT NULL REFERENCES perfis(id),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE matriculas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    aluno_id UUID NOT NULL REFERENCES perfis(id) ON DELETE CASCADE,
    escola_id UUID NOT NULL REFERENCES escolas(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    -- aluno não pode ser matriculado mais de uma vez na mesma escola
    CONSTRAINT uk_aluno_escola UNIQUE (aluno_id, escola_id)
);

-- 3. ACERVO DE QUESTÕE
CREATE TABLE questoes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    numero_identificacao INT UNIQUE NOT NULL,
    enunciado JSONB NOT NULL,
    alternativas JSONB NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. DINÂMICA DE SIMULADOS E RESPOSTAS
CREATE TABLE sessoes_simulado (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    aluno_id UUID NOT NULL REFERENCES perfis(id) ON DELETE CASCADE,
    inicio TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    termino TIMESTAMPTZ,
    estado VARCHAR(50) DEFAULT 'em andamento' CHECK (estado IN ('em andamento', 'concluida')),
    total_questoes INT DEFAULT 0,
    total_acertos INT DEFAULT 0
);

CREATE TABLE respostas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sessao_id UUID NOT NULL REFERENCES sessoes_simulado(id) ON DELETE CASCADE,
    questao_id UUID NOT NULL REFERENCES questoes(id) ON DELETE CASCADE, 
    alternativa_escolhida INT NOT NULL,
    acertou BOOLEAN NOT NULL,
    data_hora TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    -- Impede responde a mesma questão duas vezes na mesma sessão
    CONSTRAINT uk_sessao_questao UNIQUE (sessao_id, questao_id)
);