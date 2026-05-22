-- Triggers e automação
-- Função para inicializar o perfil do aluno automaticamente
CREATE OR REPLACE FUNCTION fn_inicializa_perfil()
RETURNS TRIGGER AS $$
BEGIN
    -- Inicializa o perfil definindo o papel de aluno como padrão
    INSERT INTO perfis (auth_user_id, nome_completo, papel)
    VALUES (NEW.id, 'Novo Usuário', 'aluno');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger acionada ao inserir um novo usuário na tabela auth_users
CREATE TRIGGER trg_inicializa_perfil
AFTER INSERT ON auth_users
FOR EACH ROW
EXECUTE FUNCTION fn_inicializa_perfil();

-- Políticas de segurança (RLS)
-- Ativando o Row Level Security (RLS) nas tabelas
ALTER TABLE perfis ENABLE ROW LEVEL SECURITY;
ALTER TABLE escolas ENABLE ROW LEVEL SECURITY;
ALTER TABLE matriculas ENABLE ROW LEVEL SECURITY;
ALTER TABLE questoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessoes_simulado ENABLE ROW LEVEL SECURITY;
ALTER TABLE respostas ENABLE ROW LEVEL SECURITY;

-- Questões
-- Qualquer usuário logado no sistema pode ler as questões
CREATE POLICY "Questões visíveis para todos os autenticados" 
ON questoes FOR SELECT 
USING (auth.uid() IS NOT NULL);

-- Perfis
-- O usuário controla apenas o seu próprio perfil
CREATE POLICY "Usuário acessa próprio perfil" 
ON perfis FOR ALL 
USING (auth_user_id = auth.uid());

-- Escolas
-- Admin escolar gerencia apenas a escola onde ele é o gestor 
CREATE POLICY "Admin gerencia sua escola"
ON escolas FOR ALL
USING (gestor_id IN (SELECT id FROM perfis WHERE auth_user_id = auth.uid()));

-- Matrículas
-- Aluno visualiza apenas as matrículas atreladas ao seu perfil
CREATE POLICY "Aluno vê suas matrículas"
ON matriculas FOR SELECT
USING (aluno_id IN (SELECT id FROM perfis WHERE auth_user_id = auth.uid()));

-- Simulados
-- Aluno cria e acessa apenas as suas próprias sessões de simulado
CREATE POLICY "Aluno acessa suas próprias sessões"
ON sessoes_simulado FOR ALL
USING (aluno_id IN (SELECT id FROM perfis WHERE auth_user_id = auth.uid()));

-- Respostas
-- Aluno só pode visualizar e salvar respostas em sessões que pertencem a ele
CREATE POLICY "Aluno acessa suas próprias respostas"
ON respostas FOR ALL
USING (
  sessao_id IN (
    SELECT id FROM sessoes_simulado WHERE aluno_id IN (
        SELECT id FROM perfis WHERE auth_user_id = auth.uid()
    )
  )
);