# BD: Guião 7


## ​7.2 
 
### *a)*

```
A relação está em 1ªFN, e não em 2ª nem em 3ª, pois, os atributos são atómicos e não existem relações dentro de relações.
Não é na 2ª porque existe dependências parciais como Nome_Autor para Afiliacao_Autor.
```

### *b)* 

```
2FN: 
A dependência parcial Nome_Autor -> Afiliacao_Autor deu origem a uma nova relação Autor(_Nome_Autor_, Afiliacao_Autor).
A relação inicial fica: Livro (_Titulo_Livro_, _Nome_Autor_, Tipo_Livro, Preco, NoPaginas, Editor, Endereco_Editor, Ano_Publicacao)

3FN: 
As dependências transitivas deram origem a duas novas relações: Preco(_Tipo_Livro_, _NoPaginas_, Preco) e Editor(_Editor_, Endereco_Editor).
A relação inicial fica: Livro(_Titulo_Livro_, _Nome_Autor_, Tipo_Livro, NoPaginas, Editor, Ano_Publicacao)
```




## ​7.3
 
### *a)*

```
{A,B}
```


### *b)* 

```
Até 2FN:
Dependência Parcial (A -> D,E) vai dar origem à relação R2(_A_,D,E)
Dependência Parcial (B -> F) vai dar origem à relação R3(_B_,F)
Então fica R(_A_,_B_,C,G,H,I,J)
```


### *c)* 

```
Até 3FN:
Dependências transitivas deram origem a duas relações novas R4(_F_,G,H) e R5(_D_,I,J)
Então fica R(_A_,_B_,C)
```


## ​7.4
 
### *a)*

```
{A,B}
```


### *b)* 

```
Até 3FN:
Dependências transitivas deram origem a duas relações novas R2(_D_,E) e R3(_C_,A)
Então fica R(_A_,_B_,C,D)
```


### *c)* 

```
Até BCNF:
R(_B_,_C_,D)
R2(_D_,E)
R3(_C_,A)
```



## ​7.5
 
### *a)*

```
{A,B}
```

### *b)* 

```
Até 2FN
Dependência Parcial (A -> C) vai dar origem à relação R2(_A_,C)
Então fica R(_A_,_B_,D,E)
```


### *c)* 

```
Até 3FN:
Dependências transitivas (C -> D) deu origem à relação R3(_C_,D)
Então fica R(_A_,_B_,E)
```

### *d)* 

```
As relações já estáo em BCNF.
```
