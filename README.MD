# Geração de tabelas para o relatório da Vodafone #

Este programa permite criar de forma automática a informação necessária para a elaboração do relatório semestral da Vodafone.

## Instruções a seguir ##

```
1º Passo

Fazer o export dos indicadores abaixo, nos seguintes módulos:

Indicadores de Energia:
- EA+ AVAC DTCs
- EA+ AVAC OMCs Report
- EA+ DTCs
- EA+ IT DTCs
- EA+ IT OMCs
- EA+ OMCs

com as seguintes opções selecionadas:
- Format: XLS
- Resolution: 15m
- Unit: Kilo
- Components: Only
- File from scrarch: Yes
- Include costs: No

Indicadores de Temperatura e Humidade:
- RHUMD Interior todas as médias
- TEMP Exterior todas as sondas
- TEMP Interior todas as médias
- TEMP Lisboa LPPT
- TEMP Porto LPPR

com as seguintes opções selecionadas:
- Format: XLS
- Resolution: 15m
- Unit: None
- Components: Only
- File from scrarch: Yes
```

```
2º Passo

Abrir os ficheiros exportados em .xls e converter para o formato .csv
```

```
3º Passo

Colocar os ficheiros .csv na pasta "ficheiros wisemetering" na pasta do projecto
```
> Caso a pasta "ficheiros wisemetering" não existe, tem de ser criada, respeitando o nome

```
4º Passo

Atualizar as tarifas de cada site, na pasta "tarifários"

atualizar a potência contratada do site da Boavista (?)
```

```
5º Passo

Apagar os ficheiros das pastas "ficheiros gerados" e "report" (opcional)
```

```
6º Passo

Correr a aplicação no terminal:

  > ruby vmain.rb
```


## Instalação e Setup: ##

Instalar ruby para correr a aplicação em:

> https://rubyinstaller.org/downloads/
