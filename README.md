Instruções para Execução e Resumo dos Pacotes
Visão Geral
Este projeto contém scripts SQL desenvolvidos em Oracle para gerenciamento de alunos, disciplinas e professores em um ambiente acadêmico. Ele inclui pacotes com procedures, funções e cursores para facilitar operações como cadastro, consulta e cálculo de métricas.

Pré-requisitos
Ter o Oracle Database instalado e em execução.
Acesso a um cliente SQL, como SQL*Plus, Oracle SQL Developer ou similar.
Conexão com o banco de dados contendo as tabelas:
alunos (id, nome, data_nascimento).
disciplinas (id, nome, descricao, carga_horaria, id_professor).
professores (id, nome).
matriculas (id, id_aluno, id_disciplina).
turmas (id, id_professor).
Certifique-se de que as tabelas têm os campos necessários para que os scripts sejam executados corretamente.

Instruções para Execução
Conectar ao Banco de Dados
Abra seu cliente SQL e conecte-se ao banco de dados com as credenciais apropriadas:

sql
Copiar código
CONNECT usuario/senha@nomedb;
Executar os Scripts
Copie e cole cada pacote no seu cliente SQL e execute:

sql
Copiar código
-- Exemplo para criar o pacote PKG_DISCIPLINA
@caminho_do_arquivo/pkg_disciplina.sql
Ativar a Saída de Dados (DBMS_OUTPUT)
No Oracle SQL Developer, ative o DBMS_OUTPUT:

sql
Copiar código
SET SERVEROUTPUT ON;
Chamar Procedures e Funções
Use as instruções abaixo como exemplo para executar procedures e funções:

Procedure:
sql
Copiar código
BEGIN
    PKG_DISCIPLINA.CadastrarDisciplina('Matemática', 'Curso avançado', 80);
END;
/
Função:
sql
Copiar código
DECLARE
    v_resultado VARCHAR2(100);
BEGIN
    v_resultado := PKG_PROFESSOR.ProfessorPorDisciplina(101);
    DBMS_OUTPUT.PUT_LINE('Professor: ' || v_resultado);
END;
/
Resumo dos Pacotes
PKG_ALUNO
Responsável por operações relacionadas a alunos:

ExcluirAluno: Remove um aluno e todas as suas matrículas.
ListarAlunosMaioresDe18: Lista alunos com idade superior a 18 anos.
ListarAlunosPorCurso: Lista alunos matriculados em um curso específico.
PKG_DISCIPLINA
Gerencia operações relacionadas a disciplinas:

CadastrarDisciplina: Insere uma nova disciplina.
TotalAlunosPorDisciplina: Lista disciplinas com mais de 10 alunos matriculados.
MediaIdadePorDisciplina: Calcula a média de idade dos alunos em uma disciplina.
ListarAlunosPorDisciplina: Lista os alunos de uma disciplina específica.
PKG_PROFESSOR
Gerencia operações relacionadas a professores:

TotalTurmasPorProfessor: Lista professores com mais de uma turma e o total de turmas que lecionam.
TotalTurmasProfessor: Retorna o número total de turmas de um professor específico.
ProfessorPorDisciplina: Retorna o nome do professor responsável por uma disciplina.
Observações
Verifique se todas as tabelas mencionadas possuem os dados necessários antes de executar os pacotes.
Caso encontre erros, confira os nomes das tabelas e colunas no banco de dados.
