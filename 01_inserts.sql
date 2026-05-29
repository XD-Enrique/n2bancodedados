-- 1. Inserir Utilizadores na Autenticação (auth_users)
INSERT INTO auth_users (id, email) VALUES
('a1111111-1111-1111-1111-111111111111', 'thiago@dentedeleite.com'),
('a2222222-2222-2222-2222-222222222222', 'raisa@carolinasantos.com'),
('a3333333-3333-3333-3333-333333333333', 'elena@luciarosa.com'),
('a4444444-4444-4444-4444-444444444444', 'admin@parceira.com'),
('b1111111-1111-1111-1111-111111111111', 'guilhermejorgegoncalves@nhrtaxiaereo.com'),
('b2222222-2222-2222-2222-222222222222', 'tatiane.elaine.cortereal@signa.net.br'),
('b3333333-3333-3333-3333-333333333333', 'kamillycatarinadasilva@devuono.com.br'),
('b4444444-4444-4444-4444-444444444444', 'bento-caldeira74@amoamar.com.br'),
('b5555555-5555-5555-5555-555555555555', 'leonardo-daconceicao94@6am.com.br');

-- 2. Atualizar ou Inserir os Perfis
INSERT INTO perfis (auth_user_id, nome_completo, papel) VALUES
('a1111111-1111-1111-1111-111111111111', 'Thiago Ernani Madeira', 'admin_escolar'),
('a2222222-2222-2222-2222-222222222222', 'Raisa Bauer', 'admin_escolar'),
('a3333333-3333-3333-3333-333333333333', 'Elena Parpineli de Souza', 'admin_escolar'),
('a4444444-4444-4444-4444-444444444444', 'Admin Parceira', 'admin_escolar'),
('b1111111-1111-1111-1111-111111111111', 'Guilherme Jorge Leonardo Gonçalves', 'aluno'),
('b2222222-2222-2222-2222-222222222222', 'Tatiane Elaine Giovana Corte Real', 'aluno'),
('b3333333-3333-3333-3333-333333333333', 'Kamilly Catarina da Silva', 'aluno'),
('b4444444-4444-4444-4444-444444444444', 'Bento Otávio Caldeira', 'aluno'),
('b5555555-5555-5555-5555-555555555555', 'Leonardo Oliver Gustavo da Conceição', 'aluno')
ON CONFLICT (auth_user_id) DO UPDATE SET nome_completo = EXCLUDED.nome_completo, papel = EXCLUDED.papel;

-- 3. Inserir Escolas com CNPJs e Gestores
INSERT INTO escolas (id, nome, cnpj, gestor_id) VALUES
('e1111111-1111-1111-1111-111111111111', 'Escola de Ensino Basico Dente de Leite', '42.327.876/0001-97', (SELECT id FROM perfis WHERE auth_user_id = 'a1111111-1111-1111-1111-111111111111')),
('e2222222-2222-2222-2222-222222222222', 'Escola de Ensino Medio Carolina Santos', '96.180.057/0001-99', (SELECT id FROM perfis WHERE auth_user_id = 'a2222222-2222-2222-2222-222222222222')),
('e3333333-3333-3333-3333-333333333333', 'Escola de Ensino Fundamental Lucia Rosa', '51.404.025/0001-91', (SELECT id FROM perfis WHERE auth_user_id = 'a3333333-3333-3333-3333-333333333333')),
('e4444444-4444-4444-4444-444444444444', 'Escola Abelha Feliz', '12.345.678/0001-99', (SELECT id FROM perfis WHERE auth_user_id = 'a4444444-4444-4444-4444-444444444444'));

-- 4. Inserir Matrículas (Ligação entre os Alunos e as Escolas)
INSERT INTO matriculas (aluno_id, escola_id) VALUES
((SELECT id FROM perfis WHERE auth_user_id = 'b1111111-1111-1111-1111-111111111111'), 'e1111111-1111-1111-1111-111111111111'),
((SELECT id FROM perfis WHERE auth_user_id = 'b2222222-2222-2222-2222-222222222222'), 'e4444444-4444-4444-4444-444444444444'),
((SELECT id FROM perfis WHERE auth_user_id = 'b3333333-3333-3333-3333-333333333333'), 'e2222222-2222-2222-2222-222222222222'),
((SELECT id FROM perfis WHERE auth_user_id = 'b4444444-4444-4444-4444-444444444444'), 'e4444444-4444-4444-4444-444444444444'),
((SELECT id FROM perfis WHERE auth_user_id = 'b5555555-5555-5555-5555-555555555555'), 'e3333333-3333-3333-3333-333333333333');

-- 5. Inserir Questões
-- A Questão de número 45 (UUID hexadecimal válido)
INSERT INTO questoes (id, numero_identificacao, enunciado, alternativas) VALUES 
('d4545454-4545-4545-4545-454545454545', 45, '{"texto": "Qual a capital de Portugal?"}', '[{"id": 1, "texto": "Porto"}, {"id": 2, "texto": "Lisboa"}]'::jsonb);

-- Geração automática de mais 105 questões
INSERT INTO questoes (numero_identificacao, enunciado, alternativas)
SELECT 
    n + 100, 
    ('{"texto": "Questão número ' || (n + 100) || '"}')::jsonb,
    '[{"id": 1, "texto": "A"}, {"id": 2, "texto": "B"}]'::jsonb
FROM generate_series(1, 105) AS n;

-- 6. Inserir Sessões de Simulado e Respostas

-- Cenário Q4 e Q5: A aluna Tatiane (b2) responde à Questão 45 na Escola Parceira
INSERT INTO sessoes_simulado (id, aluno_id, estado, total_questoes, total_acertos) VALUES
('f2222222-2222-2222-2222-222222222222', (SELECT id FROM perfis WHERE auth_user_id = 'b2222222-2222-2222-2222-222222222222'), 'concluida', 1, 0);

INSERT INTO respostas (sessao_id, questao_id, alternativa_escolhida, acertou) VALUES
('f2222222-2222-2222-2222-222222222222', 'd4545454-4545-4545-4545-454545454545', 1, false);

-- Cenário Q6: A aluna Kamilly (b3) gera uma inconsistência de auditoria
INSERT INTO sessoes_simulado (id, aluno_id, estado, total_questoes, total_acertos) VALUES
('f3333333-3333-3333-3333-333333333333', (SELECT id FROM perfis WHERE auth_user_id = 'b3333333-3333-3333-3333-333333333333'), 'concluida', 50, 50);
    
INSERT INTO respostas (sessao_id, questao_id, alternativa_escolhida, acertou) VALUES
('f3333333-3333-3333-3333-333333333333', (SELECT id FROM questoes WHERE numero_identificacao = 101), 1, true);

-- Cenário Q7: O aluno Bento (b4) entra no "Hall da Fama"
INSERT INTO sessoes_simulado (id, aluno_id, estado, total_questoes, total_acertos) VALUES
('f4444444-4444-4444-4444-444444444444', (SELECT id FROM perfis WHERE auth_user_id = 'b4444444-4444-4444-4444-444444444444'), 'concluida', 105, 105);

INSERT INTO respostas (sessao_id, questao_id, alternativa_escolhida, acertou)
SELECT 'f4444444-4444-4444-4444-444444444444', id, 1, true
FROM questoes WHERE numero_identificacao > 100 LIMIT 105;