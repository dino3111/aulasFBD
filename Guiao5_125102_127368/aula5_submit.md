# BD: Guião 5


## ​Problema 5.1
 
### *a)*

```
π Pname, Ssn, Fname, Lname ((employee ⨝ (ρ Ssn←Essn (works_on))) ⨝ Pno = Pnumber project)
```


### *b)* 

```
π Fname, Minit, Lname, employee.Ssn, SupervisorCarlos.SupName, SupervisorCarlos.SupMidName, SupervisorCarlos.SupLastName
(
    employee ⨝ employee.Super_ssn = SupervisorCarlos.Ssn
    (
        ρ SupervisorCarlos
        (ρ SupName←Fname,SupMidName←Minit,SupLastName←Lname
                
            π Ssn, Fname,Minit,Lname
            (
                σ (Fname = 'Carlos' ∧ Minit = 'D' ∧ Lname = 'Gomes')
                (employee)
            )
                
        )
    )
)
```


### *c)* 

```
γ Pname; sum(Hours)->total_hours (project ⨝ Pnumber = Pno works_on)
```


### *d)* 

```
π Fname, Minit, Lname
(
    σ Dno = 3 (employee) ⨝ Ssn = Essn
    (
        σ Hours > 20 (works_on) ⨝ Pno = Pnumber
        (
            π Pnumber
            (
                σ Pname = 'Aveiro Digital' (project)
            )
        )
    )
)
```


### *e)* 

```
π Fname, Minit, Lname employee - π Fname, Minit, Lname (employee ⨝ Ssn = Essn σ Essn ≠ null works_on)
```


### *f)* 

```
γ Dname; AVG(Salary) → AvgSalary
(
    department ⨝ Dnumber = Dno (σ Sex = 'F' (employee))
)
```


### *g)* 

```
π Fname, Minit, Lname
(
    employee ⨝ Ssn = Essn
    (
        σ CountDep > 2
        (
            γ Essn; COUNT(*) → CountDep (dependent)
        )
    )
)
```


### *h)* 

```
π Fname, Minit, Lname
(
    employee ⨝ Ssn = Mgr_ssn
    (
        π Mgr_ssn (department) - π Essn (dependent)
    )
)
```


### *i)* 

```
π Fname, Minit, Lname, Address
(
    employee
    ⨝ Ssn = Ssn
    (
        (
            π Essn
            (
                works_on ⨝ Pno = Pnumber
                (
                    π Pnumber (σ Plocation = 'Aveiro' (project))
                )
            )
        )
        ∩
        (
            π Ssn
            (
                employee ⨝ Dno = Dnumber
                (
                    π Dnumber (department) - π Dnumber (σ Dlocation = 'Aveiro' (dept_location))
                )
            )
        )
    )
)
```


## ​Problema 5.2

### *a)*

```
π nif (fornecedor) -
π encomenda.fornecedor
(encomenda ⨝ (nif = fornecedor) fornecedor)
```

### *b)* 

```
γ codProd; AVG(unidades) → MediaUnidades
(
    item
)
```


### *c)* 

```
γ AVG(CountProd) → MediaProdutosPorEncomenda
(
    γ numEnc; COUNT(codProd) → CountProd
    (
        item
    )
)
```


### *d)* 

```
γ fornecedor, codProd; SUM(unidades) → TotalUnidades
(
    encomenda ⨝ numero = numEnc item
)
```


## ​Problema 5.3

### *a)*

```
π paciente.numUtente, paciente.nome (σ prescricao.numUtente = null (paciente ⟕ (paciente.numUtente = prescricao.numUtente) prescricao))

```

### *b)* 

```
γ especialidade; COUNT(*) → NumPrescricoes
(
    medico ⨝ numSNS = numMedico prescricao
)
```


### *c)* 

```
γ farmacia; COUNT(*) → NumPrescricoes
(
    prescricao
)
```


### *d)* 

```
σ numPresc = null (σ numRegFarm = 906 (farmaco) ⟕ nome = nomeFarmaco σ numRegFarm = 906 (presc_farmaco))
```

### *e)* 

```
π farmacia, numRegFarm, num_farmacos_vendidos
(
    γ farmacia, numRegFarm; COUNT(nomeFarmaco) → num_farmacos_vendidos
    (
        prescricao ⨝ prescricao.numPresc = presc_farmaco.numPresc presc_farmaco
    )
)
```

### *f)* 

```
σ num_medicos > 1 (γ paciente.nome; count(prescricao.numMedico) -> num_medicos (paciente ⨝ paciente.numUtente = prescricao.numUtente prescricao))
```
