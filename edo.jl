### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ a38944d0-fe91-11ef-072f-3ff67937cf8c
using Plots, PlutoUI, HypertextLiteral, LinearAlgebra, Printf,OrdinaryDiffEq

# ╔═╡ 43f521aa-e221-4682-9a5b-fa9e68b518df
plotly();

# ╔═╡ ab0dcff5-4fe7-4367-a7db-890616a09b0c
@htl"""
<style>
	main {
		margin: 0 auto;
		max-width: 2500px;
    	padding-left: max(160px, 10%);
    	padding-right: max(160px, 10%);
	}
	pluto-output code pre {
		font-size: 90%;
	}
	pluto-input .cm-editor .cm-content .cm-scroller {
		font-size: 90%;
	}
	pluto-tree {
		font-size: 90%;
	}
	pluto-output, pluto-output table>tbody td  {
		font-size: 100%;
	    line-height: 1.8;
	}
	.plutoui-toc {
	    font-size: 90%;
	}
	.admonition-title {
		color: var(--pluto-output-h-color) !important;
	}
	pluto-output h1, pluto-output h2, pluto-output h3 {
	    border: none !important;
		line-height: 1.3 !important;
	}
	pluto-output h1 {
	    font-size: 200% !important;
	    /*border-bottom: 3px solid var(--pluto-output-color)!important;*/
	}
	pluto-output h2 {
	    font-size: 175% !important;
	    padding-top: 0.75em;
	    padding-bottom: 0.5em;
	}
	pluto-output h3 {
	    font-size: 130% !important;
	    padding-top: 0.3em;
	    padding-bottom: 0.2em;
	}
	img:not(picture *) {
	    width: 80%;
	    display: block;
	    margin-left: auto;
	    margin-right: auto;
	}
	title {
	    font-size: 200%;
	    display: block;
	    font-weight: bold;
	    text-align: left;
	    margin: 2em 0 0 0;
	}
	subtitle {
	    font-size: 140%;
	    display: block;
	    text-align: left;
	    margin: 0 0 1.5em 0;
	}
	author {
	    font-size: 120%;
	    display: block;
	    text-align: left;
	    margin: 0 0 1.5em 0;
	}
	email {
	    font-size: 100%;
	    display: block;
	    text-align: left;
	    margin: -1.8em 0 2em 0;
	}
	hr {
	color: var(--pluto-output-color);
	}
	semester {
	    font-size: 100%;
	    display: block;
	    text-align: left;
		padding-bottom: 0.5em;
	}
	blockquote {
		padding: 1.3em !important;
	}
	li::marker {
	    font-weight: bold;
	}
	li {
	    margin-top: 0.5em !important;
	    margin-bottom: 0.5em !important;
	}
	.small {
	    font-size: 80%;
	}
	.centered-image {
	    display: block;
	    margin-left: auto;
	    margin-right: auto;
	    margin-top: 1em;
	    margin-bottom: 1em;
	    width: 90%;
	}
	.hanged {
		padding-left: 3em;
		text-indent: -3em;
	}
	pluto-output details summary {
		font-family: inherit !important;
		font-weight: normal !important;
	}
</style>
"""

# ╔═╡ a9252508-2366-4e16-964c-526c475456eb
begin
	struct TwoCols{w, L, R}
		leftcolwidth::w
	    left::L
	    right::R
	end
	
	function Base.show(io, mime::MIME"text/html", tc::TwoCols)
	    write(io, """<div style="display: flex;"><div style="flex: $(tc.leftcolwidth * 100)%;padding-right:1.5em;">""")
	    show(io, mime, tc.left)
	    write(io, """</div><div style="flex: $((1.0 - tc.leftcolwidth) * 100)%;padding-left=1.5em;">""")
	    show(io, mime, tc.right)
	    write(io, """</div></div>""")
	end
end

# ╔═╡ 32806421-180c-4786-88c5-b89705615f7a
TableOfContents(title="Tópicos")

# ╔═╡ 814d1578-4044-4688-8a57-22f66ebccae5
begin
	Base.show(io::IO, f::Float64) = @printf(io, "%.4f", f)
	@htl"""
	<button onclick="present()">Apresentar</button>
	<div style="margin-top:3em;margin-bottom:7em;">
	</div>
	<title>EES100 - MÉTODOS MATEMÁTICOS PARA ENGENHARIA</title>
	<subtitle>Equações diferenciais ordinárias</subtitle>
	<author>Jonathan da Cunha Teixeira</author>
	<email><a href="mailto:jonathan.teixeira@ctec.ufal.br">jonathan.teixeira@ctec.ufal.br<a/></email>
	<semester>Programa de Pós-Graduação em Engenharia Civil<br>Universidade Federal de Alagoas</semester>
	<hr style="border-top:8px dashed;margin:2em 0em;"/>
	"""
end

# ╔═╡ 34527262-3bae-4a12-8652-fa6ea106cfb3
md"""
# Introdução

As **leis fundamentais** da física, matemática, eletrônica e termodinâmica, em geral:

- Baseadas em **observações empíricas**;
- Tentam explicar a **variação das propriedades físicas e dos estados dos sistemas**;
- Definidas em termos de **variações espaciais e temporais**.
- Combinadas com as leis de continuidade da energia, da massa e do momento, produzem **equações diferenciais**

Leis fundamentais + equações de balanço $\rightarrow$ funções matemáticas que descrevem o estado espacial e temporal deum sistema (variação de energia, massa ou velocidade).

Podemos listas as principais:

| Lei | Relação |
| --- | ------- |
| 2ª Lei de Newton | $\frac{dv}{dt} = \frac{F}{m}$ |
| Lei de Fourier | $q = \mathcal{K}_T\frac{dT}{dx}$ |
| Lei de Fick | $j = -\mathcal{D}\frac{dc}{dx}$ |
| Lei de Darcy | $q_D = -\mathcal{K}\frac{dp}{dx}$ |


"""

# ╔═╡ 5c802857-e0a0-482c-b222-9d0757a4991a
md"""
# Modelos matemáticos: Definição

É um **conjunto de equações** que podem ser usadas para **calcular a evolução espaço-temporal de um sistema físico**.

!!! note "Modelo Matemático"
	Um modelo matemático é a junção entre $(\mathcal{S}, \mathcal{P}, \mathcal{M})$ onde $\mathcal{S}$ é um **sistema**, $\mathcal{P}$ é uma **questão/problema** relacionada a $\mathcal{S}$ e $\mathcal{M}$ é um **conjunto de equações matemáticas** $\mathcal{M} = {\sum_1, \sum_2, . . . , \sum_n}$ que podem ser usadas para responder $\mathcal{P}$


Normalmente $\mathcal{M}$ é uma equação (sistema) diferencial, podendo ser ordinária (*derivadas de uma ou mais variáveis dependentes em relação a uma única variável independente*) ou parcial (*derivadas parciais de uma ou mais variáveis dependentes de duas ou mais variáveis independentes*... veremos mais adiante).

# Equações diferenciais

São equações cuja a incógnita é uma função

* Equações diferenciais ordinárias (EDOs): Dependem de uma só variável

* Equações diferenciais parciais (EDPs): Dependem de mais de uma variável

"""

# ╔═╡ b75e2519-a89c-41d3-af1e-ecf765c997a2
md"""
# Equação diferencial ordinária

Uma equação diferencial ordinária de primeira ordem, é uma equação da
forma:

$\frac{dy}{dt} = y' = f(t, y)$

sendo $f:\Omega\rightarrow\mathbb{R}$ é uma função definida no conjunto aberto $\Omega\in\mathcal{R}^2$

## Métodos de solução

1. **Solução analitica:** Se utiliza quando é possível obter a expressão matemática que satisfaz a equação diferencial. É obtida em problemas mais simples (geometria unidimensional e em alguns casos 2-D). Pode ser obtida através de integração direta da equação (*separação de variáveis*) ou após algumas manipulações (*fator integrante, exata,etc.*), porém nem sempre isso é possível,

2. **Solução numérica:** Soluções aproximadas das equações diferenciais (Ex.: Diferenças finitas - Petróleo, Hidrologia, Química; Elementos finitos - Eng. {Geo}Mecânica, Civil, etc; Volumes finitos: Petróleo, Mecânica, outros)

## Função solução

A função $y=y(t)$ é uma solução da equação diferencial ordinári a (EDO) em um intervalo $\mathcal{I}\in\mathbb{R}$ se:

1. Para o par $(t, y(t))\in\Omega,\ \forall t\in\mathcal{I}$

1. a relação $y' = f(t,y(t)),\ \forall t\in\mathcal{I}$

Em outras palavras, **é a função que quando substituída na equaçãodiferencial a transforma numa identidade**. As soluções podem ser:

- **Solução geral ou primitiva**: A família de curvas que verifica a equação diferencial, a primitiva de uma equação diferencial contem tantas constantes arbitrárias quantas forem as unidades de ordem da equação.

- **Solução particular**: solução da equação deduzida da solução geral, impondo condições iniciais ou de contorno. Geralmente as condições iniciais serão dadas para o instante inicial. Já as condições de contorno aparecem quando nas equações de ordem superior os valores da função e de suas derivadas são dadas em pontos distintos.

- **Solução singular**: Chama-se de solução singular de uma equação diferencial à envoltória da família de curvas, que é a curva tangente a todas as curvas da família.A solução singular não pode ser deduzida da equação geral. Algumas equações diferenciais não apresentam essa solução.
"""

# ╔═╡ 8231135d-906e-4462-8a57-571054e03553
let
	N = 7
	steps = 0.05
	u0 = range(0,0.8,N)
	f(u, p, t) = 1.01 * u
	tspan = (0.0, 1.0)
	prob = ODEProblem(f, u0[1], tspan)
	sol = solve(prob, Tsit5(), dt=steps)
	plot(sol, linewidth = 2, title = "Espaço solução ODE",
	    xaxis = "t", yaxis = "y(t)", label="sol-1")
	prob = ODEProblem(f, u0[2], tspan)
	sol = solve(prob, Tsit5(), dt=steps)
	plot!(sol, linewidth = 2, label = "sol-2")
	prob = ODEProblem(f, u0[3], tspan)
	sol = solve(prob, Tsit5(), dt=steps)
	plot!(sol, linewidth = 2, label = "sol-3")
	prob = ODEProblem(f, u0[4], tspan)
	sol = solve(prob, Tsit5(), dt=steps)
	plot!(sol, linewidth = 2, label = "sol-4")
	prob = ODEProblem(f, u0[5], tspan)
	sol = solve(prob, Tsit5(), dt=steps)
	plot!(sol, linewidth = 2, label = "sol-5")
	prob = ODEProblem(f, u0[6], tspan)
	sol = solve(prob, Tsit5(), dt=steps)
	plot!(sol, linewidth = 2, label = "sol-6")
	prob = ODEProblem(f, u0[7], tspan)
	sol = solve(prob, Tsit5(), dt=steps)
	plot!(sol, linewidth = 2, label = "sol-7")
end

# ╔═╡ 7570b6a9-5cdf-48ec-a384-1968f741d7ef
md"""
## Problema de valor inicial 

A forma geral de um problema de valor inicial (PVI ou IVP) para a equação:

$\begin{cases}
	\frac{dy}{dt} = f(t,y)\\
	y(t_o) = y_o
\end{cases}$

A solução para tal problema, **se existir**, é **uma curva** que satisfaz a equação diferencial no intervalo $\mathcal{I}$ e passa pelo ponto $(t_o, y_o)$.

Nem todo problema de valor inicial pode ser solucionado (existência), e se houver uma solução, nem sempre podemos afirmar que é única (unicidade), por exemplo:

$\begin{cases}
	\frac{dy}{dt} = ty^\frac{1}{2}\\
	y(0) = 0
\end{cases}$

apresenta **duas soluções** que passam pelo ponto $(0, 0)$, 

- A reta $y_1(t) = 0$
- A função $y_2(t) = \frac{t^4}{16}$

Logo, ambas as curvas satisfazem a equação e passam pelo ponto, não havendo uma solução única para o problema de valor inicial
"""

# ╔═╡ 532adb3c-253a-48cd-a4d6-e09005e0fdd6
md"""
### Teorema de Existência e Unicidade

Seja $\mathcal{R}$ uma região retangular no plano $xy$ definida por $a < x < b$, $c < y < d$, que contém o ponto $(x_o, y_o)$ em seu interior.

Se $f(x, y)$ e $\frac{\partial f}{\partial y}$ *são contínuas* em $\mathcal{R}$, então existe um intervalo $\mathcal{I}$ contendo $x_o$ e uma única função $y(x)$ definida em $\mathcal{I}$ que satisfaz o problema de valor inicial.

"""

# ╔═╡ ee79229b-e494-49f0-8803-7c194d5813da
details(
	md"""**Exemplo 1.** Determine em qual intervalo está definida a solução do seguinte problema de valor inicial:

	$\begin{cases}
		t y' + 2 y = 4 t^2\\
		y(1) = 2
	\end{cases}$
	""",
	md"""
	Se $t = 0$, temos que $y = 0$, porém a função constante nula não é solução
	do problema de valor inicial. Assim, podemos assumir que $t ̸= 0$ e dividir ambos os lados da EDO por t, obtendo:

	$y' = \frac{4t^2 - 2 y}{t}$

	Logo, $f(t,y) = \frac{4t^2 - 2 y}{t}$ e $f_y(t,y) = -\frac{2}{t}$. Como a função só está definida para $t > 0$ ou $t < 0$ e **é contínua**, sendo $t_o = 1$, temos $\mathcal{I} = (0, +∞)$. Portanto, pelo Teorema garante a
	**unicidade de solução** no intervalo $\mathcal{I}$
	"""
)


# ╔═╡ c044d604-f7e6-4e9e-8d9b-573d87f1c1cb
details(
	md"""**Exemplo 2.** Determine se o seguinte problema de valor inicial tem solução única:

	$\begin{cases}
		y'= y^\frac{1}{3}\\
		y(0) = 0
	\end{cases}$
	""",
	md"""
	A função $f(t, y) = y^\frac{1}{3}$ é uma **função contínua** para todo $(t, y)$ em seu domínio, porém $f_y(t, y) = \frac{1}{3y^\frac{2}{3}}$ , não está definida para $y = 0$. Logo, o teorema **não garante a unicidade** de solução para o problema de valor inicial.
	"""
)


# ╔═╡ a07b4f02-6fcb-4b39-89ff-10708d0feb1a
md"""
## Classificação

**Tipo**: Ordinárias ou Parciais

**Ordem**: Referente a **ordem de mais alta derivada** que nela aparece.

**Grau**: é o **grau da derivada de mais alta ordem** que nela aparece (considerando a derivadas como um "polinômio")

**Linearidade**: Linear e não-linear
"""

# ╔═╡ 64a239e5-07d7-47c4-ba3c-f169539d7955
md"""
## Equações diferenciais ordinárias lineares de primeira ordem

Uma equação diferencial ordinária linear de primeira ordem é uma equação
da forma:

$\frac{dy}{dt} + p(t) y = g(t)$

onde $p(t)$ e $g(t)$ são funções contínuas em seu domínio. 

Se $g(t) = 0$, dizemos que a equação é uma *equação diferencial ordinária linear **homogênea** de primeira ordem*, 

Se $g(t)\ne 0$ é uma *equação diferencial ordinária linear **não homogênea** de primeira ordem*.

### Solução por separação de variáveis

Dada a equação homogênea da seguite forma

$\frac{dy}{dt} = f(t,y)\qquad\text{ou}\quad M(t,y)\cdot dt + N(t,y)\cdot dy =0$

sendo $M(t,y)$ e $N(t,y)$ contínuas, diferenciáveis e integráveis, esta será de variáveis separáveis se:

1. Para $M$ e $N$ serem funções de apenas uma variável ou constantes.
2. Para $M$ e $N$ serem produtos de fatores de uma só variável.

Isto é, se a equação diferencial puder ser colocada na forma:

$P(t).dt + Q(y).dy = 0$

Desta forma, resolvemos, como o próprio nome já diz, separando as variáveis, isto é, deveremos deixar o coeficiente da diferencial $dy$ como sendo uma função exclusivamente da variável $y$, e então integramos cada diferencial, da seguinte forma:

$\int P(t) dt = \int Q(y) dy + C$
"""

# ╔═╡ ae48fc8b-1ec7-4c1d-93c0-ff7ca89f9b93
md"""
### Solução por exata

Para a equação do tipo 

$M(t,y) dt + N(t,y) dy = 0$

é denominada **diferencial exata**, se existe uma função *u(t,y)* tal que:

$du(t,y) = M(t,y)dt + N(x,y)dy$

A **condição necessária e suficiente** para que a equação diferenciável seja uma exata é que:

$\frac{\partial M(t,y)}{\partial y} = \frac{\partial N(t,y)}{\partial t}$

seja $u=f(t,y)=C$ sua solução, cuja diferencial dada por:

$du = \frac{\partial u}{\partial t}dt + \frac{\partial u}{\partial y}dy$

então por similaridades temos:

$M(t,y) = \frac{\partial u}{\partial t}\qquad\text{e}\quad N(t,y) = \frac{\partial u}{\partial y}$

Para obtermos a sua solução $u=f(t,y)$ deveremos integrar uma das identidades em relação à variável comum ($t$ ou $y$), para $M$, teremos:

$f(t,y) = \int M(t,y)dt + g(y)$

derivando parcialmente em relação a $y$:

$\frac{\partial f(t,y)}{\partial y} = \frac{\partial\int M(t,y) dt}{dy}+g'(y)$

Como $N(t,y) = \frac{\partial u}{\partial y}$ temos que:

$N(t,y) = \frac{\partial\int M(t,y) dt}{dy}+g'(y)$

Isolando $g'(y)$ e integrando em relação a $y$, chegamos:

$g(y) = \int\left(N(t,y)-\frac{\partial\int M(t,y) dt}{dy} dy\right) + C$

Substituindo na solução geral da exata,

$f(t,y) =\int M(t,y)dt + \int\left(N(t,y)-\frac{\partial\int M(t,y) dt}{dy} dy\right) + C$

### Solução por fator Integrante

Quando a equação diferencial (ED) não é exata, $\frac{\partial M(t,y)}{\partial y}\ne\frac{\partial N(t,y)}{\partial t}$, vamos supor a existência de uma função $\mu(t, y)$ que ao multiplicar toda a ED pela mesma resulta em uma ED exata:

$\mu(t,y)\left(M(t,y) dt + N(t,y)dy \right) = 0$

Para este método de solução, considere a equação diferencial,

$\frac{dy}{dt} + p(t) y = g(t)$

multiplicando por uma função $µ(t)$ adequada, resultando em um expressão que geralmente é facilmente integrada,

$\mu(t)\frac{dy}{dt}+\mu(t)p(t)y = \mu(t) g(t)$

O termo a esquerda na equação, pode ser tomado como a derivada de um produto desde que,

$\mu'(t) = \mu(t)p(t)$

sendo $µ(t)\ne 0$, dividimos ambos os lados da equação resultante e depois integramos de ambos os lados, obtendo

$\frac{\mu'(t)}{\mu(t)} = p(t)\Rightarrow\ln (\mu(t)) = \int p(t) dt + k$

tomando $k=0$, temos que o "fator integrante" é:

$\mu(t) = e^{\int p(t) dt}$

Desta forma, o termo à esquerda da equação diferencial é retornado como a derivada do produto entre as funções. Sendo assim, integramos ambos os lados de
$t_o\rightarrow t$, obtemos:

$\mu(t)y(t) = \int_{t_o}^t \mu(s)g(s)ds + C$

Portanto,

$y(t) = \frac{1}{\mu(t)}\left[\int_{t_o}^t \mu(s)g(s)ds + C \right]$

ou seja,

$y(t) = e^{-\int p(t) dt}\left[\int_{t_o}^t e^{\int p(s) ds}g(s)ds + C \right]$

Essa expressão é a solução geral para a ED. 

No caso particular em que a função $g(t) = 0$, ou seja, a equação é uma equação diferencial
ordinária linear **homogênea** de primeira ordem, sua solução geral será dada por:

$y(t) = Ce^{-\int p(t) dt}$

Então esta solução funciona para ED homogêneas e não-homogêneas.
"""

# ╔═╡ 366f7326-4b2f-41e1-b320-60aa590d8809
details(
	md"""**Exemplo 3.** Qual a solução do seguinte problema de valor inicial:

	$\begin{cases}
		t y' + 2 y = 4 t^2\\
		y(1) = 2
	\end{cases}$
	""",
	md"""
	Se $t\ne 0$, utilizando o fator integrante, temos que:
	
	$y' +\frac{2}{t} = 4t$

	Logo, $p(t)=\frac{2}{t}$ e $g(t)=4t$, temos que a solução geral para a equação:

	$y(t) = e^{-\int\frac{2}{t}dt}\left[\int_{t_o}^t e^{-\int\frac{2}{s}ds}4tds + C \right]$

	Enquanto que:

	$\int\frac{2}{t}dt=2 \ln(t)$  e 
	
	$\int e^{\int\frac{2}{s}ds}4sds = \int s^2 4 s ds = s^4$

	Portanto, a solução geral é:

	$y(t) = t^2 + \frac{c}{t^2}$

	Para encontrar c, fazemos $y(1)=2\Rightarrow c = 1$, desta forma a solução particular será:

	$y(t) = t^2 + \frac{1}{t^2}$
	"""
)


# ╔═╡ 82742096-fb91-41df-9811-42e91230d6aa
details(
	md"""**Exemplo 4.** Resolva a equação: 	$2ty + (t^2-1) y' = 0$
	""",
	md"""
	Observe que as funções $P(t, y) = 2ty$ e $Q(t, y) = t^2 − 1$ são contínuas em todo o plano ty. Além disso, P_y(t, y) = 2t = Q_t(t, y), portanto, a equação é exata. Substituindo na solução geral da exata,
	
	$f(t,y) =\int P(t,y)dt + \int\left(Q(t,y)-\frac{\partial\int P(t,y) dt}{dy} \right) + C$

	Portanto, a solução geral é:

	$f(t,y) = \underbrace{\int 2ty dt}_{t^2y} + \int\left(t^2 − 1-\underbrace{\frac{\partial\int 2ty dt}{dy}}_{t^2} \right) + C$

	Assim:

	$f(t,y) = t^2y-y+C$
	"""
)


# ╔═╡ 2dabdaad-bc63-456e-aa3e-7faf403638cc
md"""
## Métodos numéricos de solução

Considerando a ED de 1ª ordem explicitamente definida, ou seja, $F$ é uma função que retorna a derivada, ou mudança, de um estado dado um tempo e valor de estado:

$\frac{dS(t)}{dt} = F(t, S(t))$


### Séries de Taylor

Obtermos a solução através da série quando truncamos os $n$ primeiros termos. Podemos chegar a solução exata se $n\rightarrow\infty$. Desta forma:

**Solução exata**:

$S(t)= S(t_o)+\Delta t S'(t_o) + \dots + \frac{1}{n!}\Delta t^n S^{(n)}(t_o) + \dots$

**Solução aproximada**:

$S(t)= S(t_o)+\Delta t S'(t_o) + \dots + \frac{1}{n!}\Delta t^n S^{(n)}(t_o)\|_{trunc.}$

Logo termos que o erro da aproximação será:

$\epsilon(\tau) = \mathcal{O}(\Delta t^n)\approx\frac{1}{n!}\Delta t^n S^{(n)}(\tau)\qquad \tau\in [t,t+\Delta t]$

Então para podemos diminuir o erro da aproximação devemos/podemos:

- Considerar mais termos da série de Taylor, pois diminiurá a $\frac{1}{n+1!}$ (necessitando de derivadas de ordem superiores)
- Diminuir $\Delta t$


### Método de Euler

É a série de Taylor truncada no 1º termo:

$S(t)= S(t_o)+\Delta t S'(t_o) + \mathcal{O}(\Delta t^2)$

Além disso, seja $t$ uma grade numérica do intervalo $[t_0,t_f]$ com espaçamento $\Delta t$. Sem perda de generalidade, assumimos que $t_0 = 0$ e que $t_f = n\times \Delta t$ para algum inteiro positivo, $n$. A aproximação linear de $S(t)$ em torno de $t_j$ em $t_{j+1}$ é:

$S(t_{j+1}) = S(t_{j})+ (t_{j+1} - t_J)\frac{dS(t)}{dt}$

que também pode ser escrito,

$S(t_{j+1}) = S(t_j) + \Delta t\times F(t_j,S(t_j))$

Esta fórmula é chamada de **Fórmula de Euler Explícita (direta)**. 

Ela nos permite calcular uma aproximação para o estado em $S(t_{j+1})$ dado o estado em $S(t_j)$. Neste método, usamos apenas o item de primeira ordem na série de Taylor para aproximar linearmente a próxima solução.

Partindo de um dado valor inicial de $S_0 = S(t_0)$, podemos usar esta fórmula para integrar os estados até $S(t_f)$; estes valores de $S(t)$ são então uma aproximação para a solução da equação diferencial. A fórmula de Euler explícita é o método mais simples e intuitivo para resolver problemas de valor inicial. Em qualquer estado $(t_j,S(t_j))$, ela usa F naquele estado para “apontar” linearmente em direção ao próximo estado e então se move naquela direção uma distância de $\Delta t = h$, como mostrado aqui:


![image.png](data:image/png;base64,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)


#### Caracteristicas

**Método explícito**

- Requer o cálculo uma só vez da função $F(t_j,S(t_j))$
- O erro de cada passo é da ordem de $\mathcal{O}(\Delta t^2)$
- O erro global após $k$ passos é da ordem $\mathcal{O}(\Delta t)$
- Condicionalmente estável (oscila e perde estabilidade para grandes passos ~ $\Delta t$)

**Método implícito**

- Se a função $F(t_j,S(t_j))$ é não-linear, a obtenção da próxima solução será via método de Newton
- O erro de cada passo é da ordem de $\mathcal{O}(\Delta t^2)$
- O erro global após $k$ passos é da ordem $\mathcal{O}(\Delta t)$
- Incondicionalmente estável (não oscila e nem perde estabilidade para grandes passos ~ $\Delta t$)
- Mais estável que o explícito porém de mesma ordem de aproximação

### Notação unificada

$\frac{S(t_{j+1}) - S(t_{j})}{\Delta t} = \theta F(t_{j+1}) + (1 - \theta) F(t_{j})$

Com $\theta=0$ p/ Explícito;  $\theta=1$ p/ Implícito; $\theta=0.5$ p/ Diferenças centrais (Crank-Nicholson);  

"""

# ╔═╡ 031d8553-bf0c-4d71-ae20-76d0e5354bdb
md"""
#### Algoritmo

Damos uma função $F(t, S(t))$ que calcula $\frac{dS(t)}{dt}$ , uma grade numérica, $t$, do intervalo, $[t_0,t_f]$, e um valor de estado inicial $S_0 = S(t_0)$. Podemos calcular $S(t_j)$ para cada $t_j$ em t usando as seguintes etapas:

1. Armazene $S_0 = S(t_0)$ em uma matriz, $S$.
2. Calcule $S(t_1) = S_0 + h\times F(t_0, S_0)$.
3. Armazene $S_1 = S(t_1)$ em $S$.
4. Calcule $S(t_2) = S_1 + h\times F (t_1, S_1)$.
5. Armazene $S_2 = S(t_1)$ em $S$.
6. . . .
7. Calcule $S(t_f) = S_{f − 1} + h\times F(t_{f −1}, S_{f −1})$.
8. Armazene $S_f = S(t_f)$ em $S$.
9. Obtermos $S$ pela aproximação da solução para o problema de valor inicial.

Para a fórmula de Euler explícita (avançado):

$S(t_{j+1}) = S(t_j) + \Delta t\times F(t_{j},S(t_{j}))$

Para a fórmula de Euler implícita (atrasado):

$S(t_{j+1}) = S(t_j) + \Delta t\times F(t_{j+1},S(t_{j+1}))$

De uma forma geral (ao aplicar a {sistema de} EDs), teremos:

$\text{Euler avançado:}\qquad \vec{S}(t_{j+1}) = \left[\mathbb{I}+\Delta t\times A\right]\vec{S}(t_j)$

$\text{Euler atrasado:}\qquad \vec{S}(t_{j+1}) = \left[\mathbb{I}-\Delta t\times A\right]^{-1}\vec{S}(t_j)$
"""

# ╔═╡ de801713-bbf1-44f8-ab36-81191cb50b80
md"""
**Exemplo:** Dado o IVP $y' = - y$ sendo $y(0)=1$
"""

# ╔═╡ e52fa7df-1c5f-4d1a-9058-99b5b3e0126c
let
	exact(x) = exp.(-x)
	function euler(x)
		n = length(x)
		y = zeros(n)
		y[1] = 1.0
		for i=2:n
			y[i] = (1 - (x[i]-x[i-1])) * y[i-1]
		end
		y
	end
	
	h=0.5
	x₁= 3.0
	x_05 = range(0, step=h, length=ceil(Int, x₁/h)+1)
	y_05 = euler(x_05)
	plot(x_05, y_05, label="h=0.50", lw=2)
	
	h=0.25
	x₁= 3.0
	x_05 = range(0, step=h, length=ceil(Int, x₁/h)+1)
	y_05 = euler(x_05)
	plot!(x_05, y_05, label="h=0.25", lw=2)
	
	h=0.10
	x₁= 3.0
	x_05 = range(0, step=h, length=ceil(Int, x₁/h)+1)
	y_05 = euler(x_05)
	plot!(x_05, y_05, label="h=0.10", lw=2)
	xe = range(0, step=0.01, length=300)
	plot!(xe, exact(xe), label="exato", lw=2, xlabel="x", ylabel="y")
	
end

# ╔═╡ d23a6ee3-613e-4420-b2dc-ac34d72559c9
md"""
## Equações diferenciais ordinárias de 2ª ordem

Dada a equação diferencial ordinária de segunda ordem que apresenta a seguinte forma:

$\frac{d^2 y }{d t^2} =f\left(t, y, \frac{d y }{d t}\right)$

sendo $f:\Omega\subset\mathbb{R}^3\rightarrow\mathbb{R}$ uma função contínua definida em um conjunto aberto $\Omega$. Uma solução para tal equação diferencial é uma função $y = y(t)$, onde $t\in J$, $J$ é um intervalo tal que:

$y''(t)=f(t,y(t), y'(t))\quad\forall t\in J$

A equação é dita linear se a função $f$ tem a forma:

$f\left(t, y, \frac{d y }{d t}\right)=g(t)-p(t)\frac{dy}{dt} - q(t)y$

sendo: $g,p,q$ funções contínuas em $J$, portanto:

$y''(t) + p(t)y'(t) + q(t)y = g(t)$

Finalmente, um problema de valor inicial para uma equação diferencial de segunda ordem linear é:

$\begin{cases}
y''(t) + p(t)y'(t) + q(t)y = g(t),\\ y(t_o) = y_o,\\ y'(t_o) = y'_o,
\end{cases}$

onde $t_o$ pertence ao intervalo $I$ e $y_o$ e $y'_o$ pertencem a $\mathbb{R}$. Uma solução para o problema de valor inicial é uma função $y(t)$ que satisfaz tanto a equação diferencial quanto as condições iniciais fornecidas.


Como no caso do problema de valor inicial de primeira ordem, o seguinte **teorema garante a existência e unicidade** de solução para o problema de valor inicial sob certas hipóteses.

**Teorema Existência e unicidade de solução.** Sejam $p(t)$ e $q(t)$ funções contínuas em um intervalo $J$. Se $x = x_o$ é algum ponto deste intervalo, então existe uma única solução $y(t)$ para o problema de valor inicial:

$y''(t) + p(t)y'(t) + q(t)y = g(t)$

neste intervalo[^1].

Para determinar uma **família de soluções** para equações lineares de segunda ordem, é necessário **encontrar uma combinação linear entre duas soluções** cujo conjunto formado entre elas seja **linearmente independente**.


[^1] SANTOS, R. J. Introdução às equações diferenciais ordinárias. Belo Horizonte: Imprensa Universitária da UFMG, 2011. 734 p.

### Equações lineares homogêneas de 2ª ordem

São as equações em que a função $g(t) = 0$, então a equação é denominada equação diferencial ordinária linear homogênea de segunda ordem. Logo, podemos reescrever a equação como:

$y''(t) + p(t)y'(t) + q(t)y = g(t)$


**Princípio da Superposição:** Sejam $y_1(t)$ e $y_2(t)$ soluções da equação em um intervalo $J$. Então, a combinação linear:

$y(t) = c_1y_1(t) + c_2y_2(t)$

sendo $c_1$ e $c_2$ são constantes arbitrárias, também é uma solução no intervalo. Portanto, pelo princípio da superposição, estamos interessados em determinar quando a dupla de soluções $y_1(t)$ e $y_2(t)$ tal que ${y_1(t), y_2(t)}$ é **linearmente independente**. Isso será verdade, se somente se, $W(y_1, y_2)(t)\neq 0$ para todo $t\in J$, onde:

$W(y_1, y_2)(t) = det\left(\begin{bmatrix}y_1 & y_2\\ y'_1 & y'_2\end{bmatrix}\right)$

onde $W(y_1, y_2)(t)$ é chamado de **Wronskiano** das funções no ponto $t$.

### Equação diferencial linear homogênea com coeficientes constantes

São equações que podem ser escrita na forma:

$p(t)y''(t) + q(t)y'(t) + r(t)y = 0$

sendo os coeficientes $p(t),q(t),r(t)$ funções constantes, com $p(t)\ne 0$, é chamada de equação diferencial ordinária de segunda ordem linear homogênea com coeficientes constantes. Reduzindo a ordem da equação acima e, supomos que $y(t) = e^{rt}$ seja uma solução. Calculamos suas derivadas e as substituímos na equação, obtendo:


$ar^2e^{rt} + bre^{rt} + ce^{rt} = 0\Rightarrow e^{rt}[ar2 + br + c] = 0$


Como $e^{rt}\ne 0$, $\forall t\in J$, podemos concluir que

$ar^2 + br + c = 0$

Esta equação é conhecida como equação característica associada a equação diferencial. Portanto, se $r$ for a raiz da equação quadrática $\rightarrow$ $y(t) = e^{rt}$ é uma solução. Temos três possibilidades de solução a partir da natureza das raízes $r$.

**(i) Raízes reais e distintas**: Se $r_1$ e $r_2$ são raízes distintas da equação quadrática, temos as soluções: 

$y_1(t) = e^{r_1t}$ e 

$y_2(t) = e{r_2t}$.


Assim,

$W(y_1, y_2)(t) = det\left(\begin{bmatrix}e^{r_1t} & e^{r_2t}\\ r_1e^{r_1t} & r_2e^{r_2t}\end{bmatrix}\right) = r_2e^{(r_1+r_2)t}-r_1e^{(r_1+r_2)t}\ne 0$

Logo ${y_1(t), y_2(t)}$ é um conjunto fundamental de soluções para a equação, cuja solução geral é:

$y(t) = c_1e^{r_1t} + c_2e^{r_2t}$

**(ii) Raízes reais iguais**: Se $r = − \frac{b}{2a}$ é a única raíz para equação quadrática, temos que a solução geral é:

$y(t) = c_1e^{rt} + c_2te^{rt}$

sendo $r=−\frac{b}{2a}$

**(iii) Raízes complexas**: Se $r_1 = α + iβ$ e $r_2 = α − iβ$, sendo α e β números reais positivos, e $β\ne 0$ são raízes complexas para equação quadrática. A solução geral da equação nesse caso é:

$y(t) = c_1e^{αt}cos(βt) + c_2e^{αt}sen(βt)$
"""

# ╔═╡ 4d7b0ade-4e23-48cb-819b-35e0613bdb41
details(
	md"""**Exemplo 5.** Encontre a solução geral para equação: 	$y'' -3y' + 2y(t) = 0$
	""",
	md"""
	Neste caso, a equação característica é $r^2-3r+2=0$, As raízes da equação são $r_1 = 1$ e $r_2 = 2$. Portanto, a solução geral da equação diferencial é dada por:

	$y(t)=c_1e^t + c_2e^{2t}$
	"""
)


# ╔═╡ af2f9b54-7cc5-4f04-a311-ab22272c359a
details(
	md"""**Exemplo 6.** Encontre a solução geral para equação: 	$y''+2y' + 5y(t) = 0$
	""",
	md"""
	Neste caso, a equação característica é $r^2+2r+5=0$ e as suas raízes são $r_1 = -1+2i$ e $r_2 = -1-2i$. Assim:

	$y(t)=e^{-1+2i}=c_1e^{-t}cos(2t)+c_2e^{-t}sen(2t)$
	"""
)


# ╔═╡ ede74c0d-ef84-49e3-8005-0cc689aad6b6
md"""
### Equações lineares não homogêneas de segunda ordem

Para a equação não homogênea (heterogênea):

$y''(t) + p(t)y'(t) + q(t)y = g(t)$

sendo $g(t)$ é uma função contínua em $J$. Então, teremos que a solução geral será da forma:

$y(t) = \underbrace{c_1y_1(t) + c_2y_2(t)}_{solução\ da\ homogênea} + \overbrace{y_p(t)}^{Solução\ particular}$

Conhecendo a solução geral para a equação EDO homogênea associada, podemos agora utilizar dois métodos para encontrar uma solução particular presente em tal solução:

1. método de coeficientes a determinar
1. método de variação de parâmetros.

#### Método de coeficientes a determinar

O método de coeficientes a determinar é utilizado para encontrar uma solução particular para a equação não homogênea, quando seus coeficientes são constantes. Para aplicar o método, é necessário:

1. Verificar se a função $g(t)$ pode ser escrita como uma função polinomial, exponencial, seno, cosseno, bem como a soma e produto destas funções.
2. Encontramos a solução geral da equação homogênea associada, e assumimos uma solução particular para a equação na mesma família que $g(t)$, com coeficientes a determinar.
3. Calculamos as derivadas dessa função e substituímos na equação diferencial, o que nos leva a resolver um sistema linear para determinar seus coeficientes;
4. Se a solução particular encontrada já está na solução homogênea, multiplicamos a solução suposta por $t^n$, onde $n$ é o menor inteiro que remove a duplicação.

#### Método de variação de parâmetros.

O método de variação de parâmetros é utilizado para determinar a solução particular da equação de 2ª ordem heteogênea, quando seus coeficientes são funções contínuas em $\mathcal{I}$.

Sejam $y_1(t)$ e $y_2(t)$ soluções para equação homogênea associada tais que ${y_1(t), y_2(t)}$ é linearmente independente sobre $\mathbb{R}$, buscaremos uma solução particular para equação do tipo:

$y_p(t)=u_1(t)y_1(t) +u_2(t)y_2(t)$

sendo $u_1(t)$ e $u_2(t)$ os parâmetros variáveis. Para definirmos quem são esses parâmetros, vamos impor condições aos mesmos. Ao
calcular a derivada de ambos os lados, obtemos

$y_p'(t) = u'_1(t)y_1(t) + u_1(t)y'_1 (t) + u'_2(t)y_2(t) + u_2(t)y'_2(t)$

Nossa primeira condição, é que:

$u'_1(t)y_1(t) + u'_2(t)y_2(t) = 0$

deste modo a derivada se resume a

$y_p'(t) = u_1(t)y'_1 (t) + u_2(t)y'_2 (t)$

Ao derivar, novamente, em ambos os lados, encontramos:

$y_p''(t) = u'_1(t)y'_1(t) + u_1(t)y''_1(t) + u'_2(t)y'_2(t) + u_2(t)y''_2(t)$

Agora, substituindo $y_p(t)$ e suas derivadas...

$u'_1(t)y'_1(t) + u'_2(t)y'_2(t) = g(t)$

que vamos fixar como nossa segunda condição.

Das condições impostas, obtemos o seguinte sistema


$\begin{cases}
u'_1(t)y_1(t) + u'_2(t)y_2(t) = 0\\
u'_1(t)y'_1(t) + u'_2(t)y'_2(t) = g(t)
\end{cases}$

cuja forma matricial 

$\begin{bmatrix}y_1(t) & y_2(t)\\y'_1(t) & y'_2(t)\end{bmatrix}\begin{bmatrix}u'_1(t) \\ u'_2(t)\end{bmatrix} = \begin{bmatrix}0 \\ g(t)\end{bmatrix}$

o sistema possui uma única solução que pela **regra de Cramer** é dada por:

$u_1(t)=\int\frac{-g(t)y_2(t)}{W(y_1,y_2)}dt\qquad u_2(t)=\int\frac{g(t)y_1(t)}{W(y_1,y_2)}dt$

Finalmente, a solução particular será:

$y_p(t)=\underbrace{u_1(t)}_{\int\frac{-g(t)y_2(t)}{W(y_1,y_2)}dt}y_1(t) +\underbrace{u_2(t)}_{\int\frac{g(t)y_1(t)}{W(y_1,y_2)}dt}y_2(t)$

"""

# ╔═╡ 15e4e7d7-be28-4d86-8606-8e68a72ded9f
md"""
### Sistema massa-mola 

Considerando um sistema amortecido massa-mola (EDO de segunda ordem).

![spring-mass](https://math.libretexts.org/@api/deki/files/80489/clipboard_e667a8a3589f79037977e9f590a0856b8.png?revision=1)

No qual modelo é governado pela 2ª lei de Newton:

$F=ma = m\ddot{x}\Rightarrow m\ddot{x} = -kx$

sendo $x$ o deslocamento da massa a partir da configuração em repouso. Considerando $m=k=1\Rightarrow \ddot{x} = -x$

**Método de Resolução #1**: Equação de 2ª ordem com coeficientes constantes;

A EDO $\ddot{x} = -x$, apresenta a equação característica $r^2 + 1=0$, com raizes $r_1 = i$ e $r_2 = -i$, logo a solução geral é:

$x(t) = c_1cos(t) + c_2sen(t)$

Com a condição inicial $x(0) = x_o$ temos:

$x(0) = c_1cos(0) + c_2sen(0)\rightarrow c_1 = x_o$

Precisamos de outra condição inicial, considerando $\dot{x}(0)=0$, temos:

$\dot{x}(0) = x_osen(0) - c_2cos(0)\rightarrow c_2 = 0$

desta forma, a solução será:

$x(t) = x_ocos(t)$

**Método de Resolução #2**: Tentativa de solução

Qual a função, quando aplicando multiplas derivadas, é similar a ela mesma multiplicada por uma constante? 


*Resposta:* $x(t)=e^{\lambda t}$, 


Apresenta a característica da EDO:

$\dot{x} = \lambda e^{\lambda t}$
$\ddot{x} = \lambda^2 e^{\lambda t}\rightarrow \ddot{x} = -x\rightarrow\lambda^2 e^{\lambda t}=-\lambda e^{\lambda t}\Rightarrow\lambda^2=-1$

Portanto, $\lambda=\pm i$

$x(t) = c_1e^{it}+c_2e^{-it}\rightarrow (c_1+c_2)cos(t) + i(c_1-c_2)sen(t)$

Com a condição inicial $x(0) = x_o$ temos:

$x(0) = c_1 + c_2=x_o$

Da outra condição inicial, $\dot{x}(0)=0$, temos:

$\dot{x}(0) = i(c_1 - c_2)=0\Rightarrow c_1=c_2=c$

Deste modo, $c=\frac{x_o}{2}$, e a solução é:

$x(t) = x_ocos(t)$

**Método de Resolução #3**: Redução de ordem

Reduzir a ordem da EDO 2ª$\rightarrow$1ª, através de atrivuição de uma nova variável $v$, e portanto gerando um sistema de EDOs:

$\dot{x} = v$
$\dot{v} = -x$

Na forma matricial

$\frac{d}{dt}\begin{bmatrix}x\\v\end{bmatrix}=\begin{bmatrix}0 & 1\\ -1 & 0\end{bmatrix}\begin{bmatrix}x\\v\end{bmatrix}$
"""

# ╔═╡ 86764407-0e0e-44d9-8bee-b8fde107a7c5
let
	function springmass!(du, u, p, t)
		du[1] = u[2]
		du[2] = -u[1]
	end

	prob = ODEProblem(springmass!, [.5, 0], [0.0, 50.0])
	sol = solve(prob)
	plot(sol, idxs = (0, 1), label=false, title="Sistema Massa-Mola")
end

# ╔═╡ 8dec3c53-d007-4d0c-bdc2-e2c9e59be024
md"""
![spring-mass-anim](https://help.juliahub.com/multibody/dev/examples/springmass.gif)
"""

# ╔═╡ b4381585-3325-498d-9089-3e8f74201ce6
md"""
### Sistema massa-mola-amortecedor em vibração forçada 

Considerando um sistema amortecido massa-mola (EDO de segunda ordem).

![spring-mass-damper](https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Mass-Spring-Damper.svg/960px-Mass-Spring-Damper.svg.png?20051101095032)

Partindo da 2ª lei de Newton...

$F=ma\Rightarrow m\ddot{x} = -kx - B\dot{x}\quad\therefore\quad m\ddot{x} + B\dot{x} +kx = 0$

No qual modelo é:

$\frac{d^2 x}{dt^2} + 2ζ\omega_o \frac{dx}{dt} + \omega_o^2 x = 0$

por redução de ordem, produzimos o seguinte sistema de EDOs:

$\begin{cases}
	v = \frac{dx}{dt}\\
	\frac{dv}{dt} = -2ζ\omega_o v - \omega_o^2 x
\end{cases}$

onde $v$ é a velocidade, $x$ deslocamento da mola, $\omega_o=\sqrt{\frac{\kappa}{m}}$ é a frequência natural, $\zeta = \frac{B}{2\sqrt{\kappa\cdot m}}$ é a razão de amortecimento, com $B$ uma constante de amplitude de amortecimento, $\kappa$ é a constante da mola, $m$ massa do bloco. Portanto, o sistema EDO pode ser reescrito como:

$\frac{d}{dt}\begin{bmatrix}x \\ v \end{bmatrix} = \begin{bmatrix} 0 & 1 \\ -\omega_o^2 & -2\zeta\omega_o \end{bmatrix}\begin{bmatrix}x \\ v \end{bmatrix}$
"""

# ╔═╡ 816f1f5a-78f5-44fd-9986-5c9e51522ae1
let
	function springmassdamper!(du, u, p, t)
		du[1] = u[2]
		du[2] = -p[1]^2 * u[1] - 2*p[2]*p[1]*u[2]
	end

	prob = ODEProblem(springmassdamper!, [.5, 0], (0.0, 10.0),[5.0, 0.125,])
	sol = solve(prob)
	plot(sol, idxs = (0, 1), label=false, title="Sistema Massa-Mola-amortecedor")
end

# ╔═╡ 2f688dc7-8b92-4d2c-b830-184464f6d068
md"![spring-mass-damper-anim](https://help.juliahub.com/multibody/dev/examples/springdamper.gif)"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
OrdinaryDiffEq = "1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Printf = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[compat]
HypertextLiteral = "~0.9.5"
OrdinaryDiffEq = "~6.90.1"
Plots = "~1.40.9"
PlutoUI = "~0.7.61"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.9"
manifest_format = "2.0"
project_hash = "79b464be34dd5b85c8ad0debfd1dade0c381b25d"

[[deps.ADTypes]]
git-tree-sha1 = "72af59f5b8f09faee36b4ec48e014a79210f2f4f"
uuid = "47edcb42-4c32-4615-8424-f2b9edc5f35b"
version = "1.11.0"
weakdeps = ["ChainRulesCore", "ConstructionBase", "EnzymeCore"]

    [deps.ADTypes.extensions]
    ADTypesChainRulesCoreExt = "ChainRulesCore"
    ADTypesConstructionBaseExt = "ConstructionBase"
    ADTypesEnzymeCoreExt = "EnzymeCore"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.Accessors]]
deps = ["CompositionsBase", "ConstructionBase", "Dates", "InverseFunctions", "MacroTools"]
git-tree-sha1 = "0ba8f4c1f06707985ffb4804fdad1bf97b233897"
uuid = "7d9f7c33-5ae7-4f3b-8dc6-eff91059b697"
version = "0.1.41"

    [deps.Accessors.extensions]
    AxisKeysExt = "AxisKeys"
    IntervalSetsExt = "IntervalSets"
    LinearAlgebraExt = "LinearAlgebra"
    StaticArraysExt = "StaticArrays"
    StructArraysExt = "StructArrays"
    TestExt = "Test"
    UnitfulExt = "Unitful"

    [deps.Accessors.weakdeps]
    AxisKeys = "94b1ba4f-4ee9-5380-92f1-94cde586c3c5"
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
    Requires = "ae029012-a4dd-5104-9daa-d747884805df"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
    Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.Adapt]]
deps = ["LinearAlgebra", "Requires"]
git-tree-sha1 = "50c3c56a52972d78e8be9fd135bfb91c9574c140"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "4.1.1"
weakdeps = ["StaticArrays"]

    [deps.Adapt.extensions]
    AdaptStaticArraysExt = "StaticArrays"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.ArnoldiMethod]]
deps = ["LinearAlgebra", "Random", "StaticArrays"]
git-tree-sha1 = "d57bd3762d308bded22c3b82d033bff85f6195c6"
uuid = "ec485272-7323-5ecc-a04f-4719b315124d"
version = "0.4.0"

[[deps.ArrayInterface]]
deps = ["Adapt", "LinearAlgebra"]
git-tree-sha1 = "017fcb757f8e921fb44ee063a7aafe5f89b86dd1"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "7.18.0"

    [deps.ArrayInterface.extensions]
    ArrayInterfaceBandedMatricesExt = "BandedMatrices"
    ArrayInterfaceBlockBandedMatricesExt = "BlockBandedMatrices"
    ArrayInterfaceCUDAExt = "CUDA"
    ArrayInterfaceCUDSSExt = "CUDSS"
    ArrayInterfaceChainRulesCoreExt = "ChainRulesCore"
    ArrayInterfaceChainRulesExt = "ChainRules"
    ArrayInterfaceGPUArraysCoreExt = "GPUArraysCore"
    ArrayInterfaceReverseDiffExt = "ReverseDiff"
    ArrayInterfaceSparseArraysExt = "SparseArrays"
    ArrayInterfaceStaticArraysCoreExt = "StaticArraysCore"
    ArrayInterfaceTrackerExt = "Tracker"

    [deps.ArrayInterface.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    CUDSS = "45b445bb-4962-46a0-9369-b4df9d0f772e"
    ChainRules = "082447d4-558c-5d27-93f4-14fc19e9eca2"
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    GPUArraysCore = "46192b85-c4d5-4398-a991-12ede77f4527"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArraysCore = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.ArrayLayouts]]
deps = ["FillArrays", "LinearAlgebra"]
git-tree-sha1 = "2bf6e01f453284cb61c312836b4680331ddfc44b"
uuid = "4c555306-a7a7-4459-81d9-ec55ddd5c99a"
version = "1.11.0"
weakdeps = ["SparseArrays"]

    [deps.ArrayLayouts.extensions]
    ArrayLayoutsSparseArraysExt = "SparseArrays"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.BitTwiddlingConvenienceFunctions]]
deps = ["Static"]
git-tree-sha1 = "f21cfd4950cb9f0587d5067e69405ad2acd27b87"
uuid = "62783981-4cbd-42fc-bca8-16325de8dc4b"
version = "0.1.6"

[[deps.BracketingNonlinearSolve]]
deps = ["CommonSolve", "ConcreteStructs", "NonlinearSolveBase", "PrecompileTools", "Reexport", "SciMLBase"]
git-tree-sha1 = "95cb19c37ea427617e9795655667712f03058d98"
uuid = "70df07ce-3d50-431d-a3e7-ca6ddb60ac1e"
version = "1.1.0"
weakdeps = ["ForwardDiff"]

    [deps.BracketingNonlinearSolve.extensions]
    BracketingNonlinearSolveForwardDiffExt = "ForwardDiff"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1b96ea4a01afe0ea4090c5c8039690672dd13f2e"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.9+0"

[[deps.CPUSummary]]
deps = ["CpuId", "IfElse", "PrecompileTools", "Static"]
git-tree-sha1 = "5a97e67919535d6841172016c9530fd69494e5ec"
uuid = "2a0fbf3d-bb9c-48f3-b0a9-814d99fd7ab9"
version = "0.2.6"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "009060c9a6168704143100f36ab08f06c2af4642"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.2+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra"]
git-tree-sha1 = "1713c74e00545bfe14605d2a2be1712de8fbcb58"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.25.1"
weakdeps = ["SparseArrays"]

    [deps.ChainRulesCore.extensions]
    ChainRulesCoreSparseArraysExt = "SparseArrays"

[[deps.CloseOpenIntervals]]
deps = ["Static", "StaticArrayInterface"]
git-tree-sha1 = "05ba0d07cd4fd8b7a39541e31a7b0254704ea581"
uuid = "fb6a15b2-703c-40df-9091-08a04967cfa9"
version = "0.1.13"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "962834c22b66e32aa10f7611c08c8ca4e20749a9"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.8"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "403f2d8e209681fcbd9468a8514efff3ea08452e"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.29.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"
weakdeps = ["SpecialFunctions"]

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "64e15186f0aa277e174aa81798f7eb8598e0157e"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.13.0"

[[deps.CommonSolve]]
git-tree-sha1 = "0eee5eb66b1cf62cd6ad1b460238e60e4b09400c"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.4"

[[deps.CommonSubexpressions]]
deps = ["MacroTools"]
git-tree-sha1 = "cda2cfaebb4be89c9084adaca7dd7333369715c5"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.1"

[[deps.CommonWorldInvalidations]]
git-tree-sha1 = "ae52d1c52048455e85a387fbee9be553ec2b68d0"
uuid = "f70d9fcc-98c5-4d4a-abd7-e4cdeebd8ca8"
version = "1.0.0"

[[deps.Compat]]
deps = ["TOML", "UUIDs"]
git-tree-sha1 = "8ae8d32e09f0dcf42a36b90d4e17f5dd2e4c4215"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.16.0"
weakdeps = ["Dates", "LinearAlgebra"]

    [deps.Compat.extensions]
    CompatLinearAlgebraExt = "LinearAlgebra"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.CompositionsBase]]
git-tree-sha1 = "802bb88cd69dfd1509f6670416bd4434015693ad"
uuid = "a33af91c-f02d-484b-be07-31d278c5ca2b"
version = "0.1.2"
weakdeps = ["InverseFunctions"]

    [deps.CompositionsBase.extensions]
    CompositionsBaseInverseFunctionsExt = "InverseFunctions"

[[deps.ConcreteStructs]]
git-tree-sha1 = "f749037478283d372048690eb3b5f92a79432b34"
uuid = "2569d6c7-a4a2-43d3-a901-331e8e4be471"
version = "0.2.3"

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "d9d26935a0bcffc87d2613ce14c527c99fc543fd"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.5.0"

[[deps.ConstructionBase]]
git-tree-sha1 = "76219f1ed5771adbb096743bff43fb5fdd4c1157"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.5.8"

    [deps.ConstructionBase.extensions]
    ConstructionBaseIntervalSetsExt = "IntervalSets"
    ConstructionBaseLinearAlgebraExt = "LinearAlgebra"
    ConstructionBaseStaticArraysExt = "StaticArrays"

    [deps.ConstructionBase.weakdeps]
    IntervalSets = "8197267c-284f-5f27-9208-e0e47529a953"
    LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

[[deps.CpuId]]
deps = ["Markdown"]
git-tree-sha1 = "fcbb72b032692610bfbdb15018ac16a36cf2e406"
uuid = "adafc99b-e345-5852-983c-f28acb93d879"
version = "0.3.1"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Dbus_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "fc173b380865f70627d7dd1190dc2fce6cc105af"
uuid = "ee1fde0b-3d02-5ea6-8484-8dfef6360eab"
version = "1.14.10+0"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
git-tree-sha1 = "9e2f36d3c96a820c678f2f1f1782582fcf685bae"
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"
version = "1.9.1"

[[deps.DiffEqBase]]
deps = ["ArrayInterface", "ConcreteStructs", "DataStructures", "DocStringExtensions", "EnumX", "EnzymeCore", "FastBroadcast", "FastClosures", "FastPower", "ForwardDiff", "FunctionWrappers", "FunctionWrappersWrappers", "LinearAlgebra", "Logging", "Markdown", "MuladdMacro", "Parameters", "PreallocationTools", "PrecompileTools", "Printf", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLOperators", "SciMLStructures", "Setfield", "Static", "StaticArraysCore", "Statistics", "TruncatedStacktraces"]
git-tree-sha1 = "b1e23a7fe7371934d9d538114a7e7166c1d09e05"
uuid = "2b5f629d-d688-5b77-993f-72d75c75574e"
version = "6.161.0"

    [deps.DiffEqBase.extensions]
    DiffEqBaseCUDAExt = "CUDA"
    DiffEqBaseChainRulesCoreExt = "ChainRulesCore"
    DiffEqBaseDistributionsExt = "Distributions"
    DiffEqBaseEnzymeExt = ["ChainRulesCore", "Enzyme"]
    DiffEqBaseGeneralizedGeneratedExt = "GeneralizedGenerated"
    DiffEqBaseMPIExt = "MPI"
    DiffEqBaseMeasurementsExt = "Measurements"
    DiffEqBaseMonteCarloMeasurementsExt = "MonteCarloMeasurements"
    DiffEqBaseReverseDiffExt = "ReverseDiff"
    DiffEqBaseSparseArraysExt = "SparseArrays"
    DiffEqBaseTrackerExt = "Tracker"
    DiffEqBaseUnitfulExt = "Unitful"

    [deps.DiffEqBase.weakdeps]
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
    GeneralizedGenerated = "6b9d7cbe-bcb9-11e9-073f-15a7a543e2eb"
    MPI = "da04e1cc-30fd-572f-bb4f-1f8673147195"
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    MonteCarloMeasurements = "0987c9cc-fe09-11e8-30f0-b96dd679fdca"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "23163d55f885173722d1e4cf0f6110cdbaf7e272"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.15.1"

[[deps.DifferentiationInterface]]
deps = ["ADTypes", "LinearAlgebra"]
git-tree-sha1 = "56816564cdb73cab9978dfb31dfb477ede88e3e4"
uuid = "a0c0ee7d-e4b9-4e03-894e-1c5f64a51d63"
version = "0.6.29"

    [deps.DifferentiationInterface.extensions]
    DifferentiationInterfaceChainRulesCoreExt = "ChainRulesCore"
    DifferentiationInterfaceDiffractorExt = "Diffractor"
    DifferentiationInterfaceEnzymeExt = ["EnzymeCore", "Enzyme"]
    DifferentiationInterfaceFastDifferentiationExt = "FastDifferentiation"
    DifferentiationInterfaceFiniteDiffExt = "FiniteDiff"
    DifferentiationInterfaceFiniteDifferencesExt = "FiniteDifferences"
    DifferentiationInterfaceForwardDiffExt = ["ForwardDiff", "DiffResults"]
    DifferentiationInterfaceMooncakeExt = "Mooncake"
    DifferentiationInterfacePolyesterForwardDiffExt = "PolyesterForwardDiff"
    DifferentiationInterfaceReverseDiffExt = ["ReverseDiff", "DiffResults"]
    DifferentiationInterfaceSparseArraysExt = "SparseArrays"
    DifferentiationInterfaceSparseMatrixColoringsExt = "SparseMatrixColorings"
    DifferentiationInterfaceStaticArraysExt = "StaticArrays"
    DifferentiationInterfaceSymbolicsExt = "Symbolics"
    DifferentiationInterfaceTrackerExt = "Tracker"
    DifferentiationInterfaceZygoteExt = ["Zygote", "ForwardDiff"]

    [deps.DifferentiationInterface.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DiffResults = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
    Diffractor = "9f5e2b26-1114-432f-b630-d3fe2085c51c"
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
    EnzymeCore = "f151be2c-9106-41f4-ab19-57ee4f262869"
    FastDifferentiation = "eb9bf01b-bf85-4b60-bf87-ee5de06c00be"
    FiniteDiff = "6a86dc24-6348-571c-b903-95158fe2bd41"
    FiniteDifferences = "26cc04aa-876d-5657-8c51-4c34ba976000"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    Mooncake = "da2b9cff-9c12-43a0-ae48-6db2b0edb7d6"
    PolyesterForwardDiff = "98d1487c-24ca-40b6-b7ab-df2af84e126b"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SparseMatrixColorings = "0a514795-09f3-496d-8182-132a7b665d35"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
    Symbolics = "0c5d862f-8b57-4792-8d23-62f2024744c7"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.EnumX]]
git-tree-sha1 = "bdb1942cd4c45e3c678fd11569d5cccd80976237"
uuid = "4e289a0a-7415-4d19-859d-a7e5c4648b56"
version = "1.0.4"

[[deps.EnzymeCore]]
git-tree-sha1 = "0cdb7af5c39e92d78a0ee8d0a447d32f7593137e"
uuid = "f151be2c-9106-41f4-ab19-57ee4f262869"
version = "0.8.8"
weakdeps = ["Adapt"]

    [deps.EnzymeCore.extensions]
    AdaptExt = "Adapt"

[[deps.EpollShim_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a4be429317c42cfae6a7fc03c31bad1970c310d"
uuid = "2702e6a9-849d-5ed8-8c21-79e8b8f9ee43"
version = "0.0.20230411+1"

[[deps.ExceptionUnwrapping]]
deps = ["Test"]
git-tree-sha1 = "d36f682e590a83d63d1c7dbd287573764682d12a"
uuid = "460bff9d-24e4-43bc-9d9f-a8973cb893f4"
version = "0.1.11"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d55dffd9ae73ff72f1c0482454dcf2ec6c6c4a63"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.6.5+0"

[[deps.ExponentialUtilities]]
deps = ["Adapt", "ArrayInterface", "GPUArraysCore", "GenericSchur", "LinearAlgebra", "PrecompileTools", "Printf", "SparseArrays", "libblastrampoline_jll"]
git-tree-sha1 = "cae251c76f353e32d32d76fae2fea655eab652af"
uuid = "d4d017d3-3776-5f7e-afef-a10c40355c18"
version = "1.27.0"
weakdeps = ["StaticArrays"]

    [deps.ExponentialUtilities.extensions]
    ExponentialUtilitiesStaticArraysExt = "StaticArrays"

[[deps.ExprTools]]
git-tree-sha1 = "27415f162e6028e81c72b82ef756bf321213b6ec"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.10"

[[deps.Expronicon]]
deps = ["MLStyle", "Pkg", "TOML"]
git-tree-sha1 = "fc3951d4d398b5515f91d7fe5d45fc31dccb3c9b"
uuid = "6b7a57c9-7cc1-4fdf-b7f5-e857abae3636"
version = "0.8.5"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "53ebe7511fa11d33bec688a9178fac4e49eeee00"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.2"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "466d45dc38e15794ec7d5d63ec03d776a9aff36e"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.4+1"

[[deps.FastBroadcast]]
deps = ["ArrayInterface", "LinearAlgebra", "Polyester", "Static", "StaticArrayInterface", "StrideArraysCore"]
git-tree-sha1 = "ab1b34570bcdf272899062e1a56285a53ecaae08"
uuid = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
version = "0.3.5"

[[deps.FastClosures]]
git-tree-sha1 = "acebe244d53ee1b461970f8910c235b259e772ef"
uuid = "9aa1b823-49e4-5ca5-8b0f-3971ec8bab6a"
version = "0.3.2"

[[deps.FastGaussQuadrature]]
deps = ["LinearAlgebra", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "fd923962364b645f3719855c88f7074413a6ad92"
uuid = "442a2c76-b920-505d-bb47-c5924d526838"
version = "1.0.2"

[[deps.FastLapackInterface]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "cbf5edddb61a43669710cbc2241bc08b36d9e660"
uuid = "29a986be-02c6-4525-aec4-84b980013641"
version = "2.0.4"

[[deps.FastPower]]
git-tree-sha1 = "58c3431137131577a7c379d00fea00be524338fb"
uuid = "a4df4552-cc26-4903-aec0-212e50a0e84b"
version = "1.1.1"

    [deps.FastPower.extensions]
    FastPowerEnzymeExt = "Enzyme"
    FastPowerForwardDiffExt = "ForwardDiff"
    FastPowerMeasurementsExt = "Measurements"
    FastPowerMonteCarloMeasurementsExt = "MonteCarloMeasurements"
    FastPowerReverseDiffExt = "ReverseDiff"
    FastPowerTrackerExt = "Tracker"

    [deps.FastPower.weakdeps]
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    MonteCarloMeasurements = "0987c9cc-fe09-11e8-30f0-b96dd679fdca"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "6a70198746448456524cb442b8af316927ff3e1a"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "1.13.0"

    [deps.FillArrays.extensions]
    FillArraysPDMatsExt = "PDMats"
    FillArraysSparseArraysExt = "SparseArrays"
    FillArraysStatisticsExt = "Statistics"

    [deps.FillArrays.weakdeps]
    PDMats = "90014a1f-27ba-587c-ab20-58faa44d9150"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Setfield"]
git-tree-sha1 = "84e3a47db33be7248daa6274b287507dd6ff84e8"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.26.2"

    [deps.FiniteDiff.extensions]
    FiniteDiffBandedMatricesExt = "BandedMatrices"
    FiniteDiffBlockBandedMatricesExt = "BlockBandedMatrices"
    FiniteDiffSparseArraysExt = "SparseArrays"
    FiniteDiffStaticArraysExt = "StaticArrays"

    [deps.FiniteDiff.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Zlib_jll"]
git-tree-sha1 = "21fac3c77d7b5a9fc03b0ec503aa1a6392c34d2b"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.15.0+0"

[[deps.Format]]
git-tree-sha1 = "9c68794ef81b08086aeb32eeaf33531668d5f5fc"
uuid = "1fa38f19-a742-5d3f-a2b9-30dd87b9d5f8"
version = "1.3.7"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions"]
git-tree-sha1 = "a2df1b776752e3f344e5116c06d75a10436ab853"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.38"
weakdeps = ["StaticArrays"]

    [deps.ForwardDiff.extensions]
    ForwardDiffStaticArraysExt = "StaticArrays"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "786e968a8d2fb167f2e4880baba62e0e26bd8e4e"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.13.3+1"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "846f7026a9decf3679419122b49f8a1fdb48d2d5"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.16+0"

[[deps.FunctionWrappers]]
git-tree-sha1 = "d62485945ce5ae9c0c48f124a84998d755bae00e"
uuid = "069b7b12-0de2-55c6-9aab-29f3d0a68a2e"
version = "1.1.3"

[[deps.FunctionWrappersWrappers]]
deps = ["FunctionWrappers"]
git-tree-sha1 = "b104d487b34566608f8b4e1c39fb0b10aa279ff8"
uuid = "77dc65aa-8811-40c2-897b-53d922fa7daf"
version = "0.1.3"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll", "libdecor_jll", "xkbcommon_jll"]
git-tree-sha1 = "fcb0584ff34e25155876418979d4c8971243bb89"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.4.0+2"

[[deps.GPUArraysCore]]
deps = ["Adapt"]
git-tree-sha1 = "83cf05ab16a73219e5f6bd1bdfa9848fa24ac627"
uuid = "46192b85-c4d5-4398-a991-12ede77f4527"
version = "0.2.0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Preferences", "Printf", "Qt6Wayland_jll", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "p7zip_jll"]
git-tree-sha1 = "0ff136326605f8e06e9bcf085a356ab312eef18a"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.13"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "9cb62849057df859575fc1dda1e91b82f8609709"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.13+0"

[[deps.GenericSchur]]
deps = ["LinearAlgebra", "Printf"]
git-tree-sha1 = "af49a0851f8113fcfae2ef5027c6d49d0acec39b"
uuid = "c145ed77-6b09-5dd9-b285-bf645a82121e"
version = "0.5.4"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Zlib_jll"]
git-tree-sha1 = "b0036b392358c80d2d2124746c2bf3d48d457938"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.82.4+0"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "01979f9b37367603e2848ea225918a3b3861b606"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+1"

[[deps.Graphs]]
deps = ["ArnoldiMethod", "Compat", "DataStructures", "Distributed", "Inflate", "LinearAlgebra", "Random", "SharedArrays", "SimpleTraits", "SparseArrays", "Statistics"]
git-tree-sha1 = "1dc470db8b1131cfc7fb4c115de89fe391b9e780"
uuid = "86223c79-3864-5bf0-83f7-82e725a168b6"
version = "1.12.0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "CodecZlib", "ConcurrentUtilities", "Dates", "ExceptionUnwrapping", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "PrecompileTools", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "c67b33b085f6e2faf8bf79a61962e7339a81129c"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.10.15"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll"]
git-tree-sha1 = "55c53be97790242c29031e5cd45e8ac296dadda3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "8.5.0+0"

[[deps.HostCPUFeatures]]
deps = ["BitTwiddlingConvenienceFunctions", "IfElse", "Libdl", "Static"]
git-tree-sha1 = "8e070b599339d622e9a081d17230d74a5c473293"
uuid = "3e5b6fbb-0976-4d2c-9146-d79de83f2fb0"
version = "0.1.17"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.Inflate]]
git-tree-sha1 = "d1b1b796e47d94588b3757fe84fbf65a5ec4a80d"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.5"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl"]
git-tree-sha1 = "10bd689145d2c3b2a9844005d01087cc1194e79e"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2024.2.1+0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
git-tree-sha1 = "a779299d77cd080bf77b97535acecd73e1c5e5cb"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.17"
weakdeps = ["Dates", "Test"]

    [deps.InverseFunctions.extensions]
    InverseFunctionsDatesExt = "Dates"
    InverseFunctionsTestExt = "Test"

[[deps.IrrationalConstants]]
git-tree-sha1 = "e2222959fbc6c19554dc15174c81bf7bf3aa691c"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.4"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "71b48d857e86bf7a1838c4736545699974ce79a2"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.9"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "a007feb38b422fbdab534406aeca1b86823cb4d6"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.7.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "eac1206917768cb54957c65a615460d87b455fc1"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.1.1+0"

[[deps.KLU]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse_jll"]
git-tree-sha1 = "07649c499349dad9f08dde4243a4c597064663e9"
uuid = "ef3ab10e-7fda-4108-b977-705223b18434"
version = "0.6.0"

[[deps.Krylov]]
deps = ["LinearAlgebra", "Printf", "SparseArrays"]
git-tree-sha1 = "4f20a2df85a9e5d55c9e84634bbf808ed038cabd"
uuid = "ba0b0d4f-ebba-5204-a429-3ac8c609bfb7"
version = "0.9.8"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "170b660facf5df5de098d866564877e119141cbd"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.2+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "aaafe88dccbd957a8d82f7d05be9b69172e0cee3"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "4.0.1+0"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "78211fb6cbc872f77cad3fc0b6cf647d923f4929"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "18.1.7+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1c602b1127f4751facb671441ca72715cc95938a"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.3+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "cd714447457c660382fe634710fb56eb255ee42e"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.6"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SparseArraysExt = "SparseArrays"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

[[deps.LayoutPointers]]
deps = ["ArrayInterface", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "a9eaadb366f5493a5654e843864c13d8b107548c"
uuid = "10f19ff3-798f-405d-979b-55457f8fc047"
version = "0.1.17"

[[deps.LazyArrays]]
deps = ["ArrayLayouts", "FillArrays", "LinearAlgebra", "MacroTools", "SparseArrays"]
git-tree-sha1 = "f289bee714e11708df257c57514585863aa02b33"
uuid = "5078a376-72f3-5289-bfd5-ec5146d43c02"
version = "2.3.1"

    [deps.LazyArrays.extensions]
    LazyArraysBandedMatricesExt = "BandedMatrices"
    LazyArraysBlockArraysExt = "BlockArrays"
    LazyArraysBlockBandedMatricesExt = "BlockBandedMatrices"
    LazyArraysStaticArraysExt = "StaticArrays"

    [deps.LazyArrays.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockArrays = "8e7c35d0-a365-5155-bbbb-fb81a777f24e"
    BlockBandedMatrices = "ffab5731-97b5-5995-9138-79e8c1846df0"
    StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "27ecae93dd25ee0909666e6835051dd684cc035e"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+2"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll"]
git-tree-sha1 = "8be878062e0ffa2c3f67bb58a595375eda5de80b"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.11.0+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "ff3b4b9d35de638936a525ecd36e86a8bb919d11"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.7.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "df37206100d39f79b3376afb6b9cee4970041c61"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.51.1+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "be484f5c92fad0bd8acfef35fe017900b0b73809"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.18.0+0"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "89211ea35d9df5831fca5d33552c02bd33878419"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.40.3+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "4ab7581296671007fc33f07a721631b8855f4b1d"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.7.1+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e888ad02ce716b319e6bdb985d2ef300e7089889"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.40.3+0"

[[deps.LineSearch]]
deps = ["ADTypes", "CommonSolve", "ConcreteStructs", "FastClosures", "LinearAlgebra", "MaybeInplace", "SciMLBase", "SciMLJacobianOperators", "StaticArraysCore"]
git-tree-sha1 = "97d502765cc5cf3a722120f50da03c2474efce04"
uuid = "87fe0de2-c867-4266-b59a-2f0a94fc965b"
version = "0.1.4"
weakdeps = ["LineSearches"]

    [deps.LineSearch.extensions]
    LineSearchLineSearchesExt = "LineSearches"

[[deps.LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "e4c3be53733db1051cc15ecf573b1042b3a712a1"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.3.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LinearSolve]]
deps = ["ArrayInterface", "ChainRulesCore", "ConcreteStructs", "DocStringExtensions", "EnumX", "FastLapackInterface", "GPUArraysCore", "InteractiveUtils", "KLU", "Krylov", "LazyArrays", "Libdl", "LinearAlgebra", "MKL_jll", "Markdown", "PrecompileTools", "Preferences", "RecursiveFactorization", "Reexport", "SciMLBase", "SciMLOperators", "Setfield", "SparseArrays", "Sparspak", "StaticArraysCore", "UnPack"]
git-tree-sha1 = "9d5872d134bd33dd3e120767004f760770958863"
uuid = "7ed4a6bd-45f5-4d41-b270-4a48e9bafcae"
version = "2.38.0"

    [deps.LinearSolve.extensions]
    LinearSolveBandedMatricesExt = "BandedMatrices"
    LinearSolveBlockDiagonalsExt = "BlockDiagonals"
    LinearSolveCUDAExt = "CUDA"
    LinearSolveCUDSSExt = "CUDSS"
    LinearSolveEnzymeExt = "EnzymeCore"
    LinearSolveFastAlmostBandedMatricesExt = "FastAlmostBandedMatrices"
    LinearSolveHYPREExt = "HYPRE"
    LinearSolveIterativeSolversExt = "IterativeSolvers"
    LinearSolveKernelAbstractionsExt = "KernelAbstractions"
    LinearSolveKrylovKitExt = "KrylovKit"
    LinearSolveMetalExt = "Metal"
    LinearSolvePardisoExt = "Pardiso"
    LinearSolveRecursiveArrayToolsExt = "RecursiveArrayTools"

    [deps.LinearSolve.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    BlockDiagonals = "0a1fb500-61f7-11e9-3c65-f5ef3456f9f0"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"
    CUDSS = "45b445bb-4962-46a0-9369-b4df9d0f772e"
    EnzymeCore = "f151be2c-9106-41f4-ab19-57ee4f262869"
    FastAlmostBandedMatrices = "9d29842c-ecb8-4973-b1e9-a27b1157504e"
    HYPRE = "b5ffcf37-a2bd-41ab-a3da-4bd9bc8ad771"
    IterativeSolvers = "42fd0dbc-a981-5370-80f2-aaf504508153"
    KernelAbstractions = "63c18a36-062a-441e-b654-da1e3ab1ce7c"
    KrylovKit = "0b1a1467-8014-51b9-945f-bf0ae24f4b77"
    Metal = "dde4c033-4e86-420c-a63e-0dd931031962"
    Pardiso = "46dd5b70-b6fb-5a00-ae2d-e8fea33afaf2"
    RecursiveArrayTools = "731186ca-8d62-57ce-b412-fbd966d074cd"

[[deps.LogExpFunctions]]
deps = ["DocStringExtensions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "13ca9e2586b89836fd20cccf56e57e2b9ae7f38f"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.29"

    [deps.LogExpFunctions.extensions]
    LogExpFunctionsChainRulesCoreExt = "ChainRulesCore"
    LogExpFunctionsChangesOfVariablesExt = "ChangesOfVariables"
    LogExpFunctionsInverseFunctionsExt = "InverseFunctions"

    [deps.LogExpFunctions.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    ChangesOfVariables = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "f02b56007b064fbfddb4c9cd60161b6dd0f40df3"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.1.0"

[[deps.LoopVectorization]]
deps = ["ArrayInterface", "CPUSummary", "CloseOpenIntervals", "DocStringExtensions", "HostCPUFeatures", "IfElse", "LayoutPointers", "LinearAlgebra", "OffsetArrays", "PolyesterWeave", "PrecompileTools", "SIMDTypes", "SLEEFPirates", "Static", "StaticArrayInterface", "ThreadingUtilities", "UnPack", "VectorizationBase"]
git-tree-sha1 = "8084c25a250e00ae427a379a5b607e7aed96a2dd"
uuid = "bdcacae8-1622-11e9-2a5c-532679323890"
version = "0.12.171"
weakdeps = ["ChainRulesCore", "ForwardDiff", "SpecialFunctions"]

    [deps.LoopVectorization.extensions]
    ForwardDiffExt = ["ChainRulesCore", "ForwardDiff"]
    SpecialFunctionsExt = "SpecialFunctions"

[[deps.MIMEs]]
git-tree-sha1 = "1833212fd6f580c20d4291da9c1b4e8a655b128e"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.0.0"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "oneTBB_jll"]
git-tree-sha1 = "f046ccd0c6db2832a9f639e2c669c6fe867e5f4f"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2024.2.0+0"

[[deps.MLStyle]]
git-tree-sha1 = "bc38dff0548128765760c79eb7388a4b37fae2c8"
uuid = "d8e11817-5142-5d16-987a-aa16d5891078"
version = "0.4.17"

[[deps.MacroTools]]
git-tree-sha1 = "72aebe0b5051e5143a079a4685a46da330a40472"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.15"

[[deps.ManualMemory]]
git-tree-sha1 = "bcaef4fc7a0cfe2cba636d84cda54b5e4e4ca3cd"
uuid = "d125e4d3-2237-4719-b19c-fa641b8a4667"
version = "0.1.8"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MaybeInplace]]
deps = ["ArrayInterface", "LinearAlgebra", "MacroTools"]
git-tree-sha1 = "54e2fdc38130c05b42be423e90da3bade29b74bd"
uuid = "bb5d69b7-63fc-4a16-80bd-7e42200c7bdb"
version = "0.1.4"
weakdeps = ["SparseArrays"]

    [deps.MaybeInplace.extensions]
    MaybeInplaceSparseArraysExt = "SparseArrays"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "NetworkOptions", "Random", "Sockets"]
git-tree-sha1 = "c067a280ddc25f196b5e7df3877c6b226d390aaf"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.9"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "ec4f7fbeab05d7747bdf98eb74d130a2a2ed298d"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.2.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.MuladdMacro]]
git-tree-sha1 = "cac9cc5499c25554cba55cd3c30543cff5ca4fab"
uuid = "46d2c3a1-f734-5fdb-9937-b9b9aeba4221"
version = "0.2.4"

[[deps.NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "a0b464d183da839699f4c79e7606d9d186ec172c"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.3"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "cc0a5deefdb12ab3a096f00a6d42133af4560d71"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.1.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.NonlinearSolve]]
deps = ["ADTypes", "ArrayInterface", "BracketingNonlinearSolve", "CommonSolve", "ConcreteStructs", "DiffEqBase", "DifferentiationInterface", "FastClosures", "FiniteDiff", "ForwardDiff", "LineSearch", "LinearAlgebra", "LinearSolve", "NonlinearSolveBase", "NonlinearSolveFirstOrder", "NonlinearSolveQuasiNewton", "NonlinearSolveSpectralMethods", "PrecompileTools", "Preferences", "Reexport", "SciMLBase", "SimpleNonlinearSolve", "SparseArrays", "SparseMatrixColorings", "StaticArraysCore", "SymbolicIndexingInterface"]
git-tree-sha1 = "d0caebdb5a31e1a11ca9f7f189cdbf341ac89f0e"
uuid = "8913a72c-1f9b-4ce2-8d82-65094dcecaec"
version = "4.3.0"

    [deps.NonlinearSolve.extensions]
    NonlinearSolveFastLevenbergMarquardtExt = "FastLevenbergMarquardt"
    NonlinearSolveFixedPointAccelerationExt = "FixedPointAcceleration"
    NonlinearSolveLeastSquaresOptimExt = "LeastSquaresOptim"
    NonlinearSolveMINPACKExt = "MINPACK"
    NonlinearSolveNLSolversExt = "NLSolvers"
    NonlinearSolveNLsolveExt = ["NLsolve", "LineSearches"]
    NonlinearSolvePETScExt = ["PETSc", "MPI"]
    NonlinearSolveSIAMFANLEquationsExt = "SIAMFANLEquations"
    NonlinearSolveSpeedMappingExt = "SpeedMapping"
    NonlinearSolveSundialsExt = "Sundials"

    [deps.NonlinearSolve.weakdeps]
    FastLevenbergMarquardt = "7a0df574-e128-4d35-8cbd-3d84502bf7ce"
    FixedPointAcceleration = "817d07cb-a79a-5c30-9a31-890123675176"
    LeastSquaresOptim = "0fc2ff8b-aaa3-5acd-a817-1944a5e08891"
    LineSearches = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
    MINPACK = "4854310b-de5a-5eb6-a2a5-c1dee2bd17f9"
    MPI = "da04e1cc-30fd-572f-bb4f-1f8673147195"
    NLSolvers = "337daf1e-9722-11e9-073e-8b9effe078ba"
    NLsolve = "2774e3e8-f4cf-5e23-947b-6d7e65073b56"
    PETSc = "ace2c81b-2b5f-4b1e-a30d-d662738edfe0"
    SIAMFANLEquations = "084e46ad-d928-497d-ad5e-07fa361a48c4"
    SpeedMapping = "f1835b91-879b-4a3f-a438-e4baacf14412"
    Sundials = "c3572dad-4567-51f8-b174-8c6c989267f4"

[[deps.NonlinearSolveBase]]
deps = ["ADTypes", "Adapt", "ArrayInterface", "CommonSolve", "Compat", "ConcreteStructs", "DifferentiationInterface", "EnzymeCore", "FastClosures", "LinearAlgebra", "Markdown", "MaybeInplace", "Preferences", "Printf", "RecursiveArrayTools", "SciMLBase", "SciMLJacobianOperators", "SciMLOperators", "StaticArraysCore", "SymbolicIndexingInterface", "TimerOutputs"]
git-tree-sha1 = "5bca24ce7b0c034dcbdc6ad6d658b02e0eed566e"
uuid = "be0214bd-f91f-a760-ac4e-3421ce2b2da0"
version = "1.4.0"

    [deps.NonlinearSolveBase.extensions]
    NonlinearSolveBaseBandedMatricesExt = "BandedMatrices"
    NonlinearSolveBaseDiffEqBaseExt = "DiffEqBase"
    NonlinearSolveBaseForwardDiffExt = "ForwardDiff"
    NonlinearSolveBaseLineSearchExt = "LineSearch"
    NonlinearSolveBaseLinearSolveExt = "LinearSolve"
    NonlinearSolveBaseSparseArraysExt = "SparseArrays"
    NonlinearSolveBaseSparseMatrixColoringsExt = "SparseMatrixColorings"

    [deps.NonlinearSolveBase.weakdeps]
    BandedMatrices = "aae01518-5342-5314-be14-df237901396f"
    DiffEqBase = "2b5f629d-d688-5b77-993f-72d75c75574e"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    LineSearch = "87fe0de2-c867-4266-b59a-2f0a94fc965b"
    LinearSolve = "7ed4a6bd-45f5-4d41-b270-4a48e9bafcae"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SparseMatrixColorings = "0a514795-09f3-496d-8182-132a7b665d35"

[[deps.NonlinearSolveFirstOrder]]
deps = ["ADTypes", "ArrayInterface", "CommonSolve", "ConcreteStructs", "DiffEqBase", "FiniteDiff", "ForwardDiff", "LineSearch", "LinearAlgebra", "LinearSolve", "MaybeInplace", "NonlinearSolveBase", "PrecompileTools", "Reexport", "SciMLBase", "SciMLJacobianOperators", "Setfield", "StaticArraysCore"]
git-tree-sha1 = "a1ea35ab0bcc99753e26d574ba1e339f19d100fa"
uuid = "5959db7a-ea39-4486-b5fe-2dd0bf03d60d"
version = "1.2.0"

[[deps.NonlinearSolveQuasiNewton]]
deps = ["ArrayInterface", "CommonSolve", "ConcreteStructs", "DiffEqBase", "LinearAlgebra", "LinearSolve", "MaybeInplace", "NonlinearSolveBase", "PrecompileTools", "Reexport", "SciMLBase", "SciMLOperators", "StaticArraysCore"]
git-tree-sha1 = "8f14b848afcfc0a2941cd3cca1bef04c987465bb"
uuid = "9a2c21bd-3a47-402d-9113-8faf9a0ee114"
version = "1.1.0"
weakdeps = ["ForwardDiff"]

    [deps.NonlinearSolveQuasiNewton.extensions]
    NonlinearSolveQuasiNewtonForwardDiffExt = "ForwardDiff"

[[deps.NonlinearSolveSpectralMethods]]
deps = ["CommonSolve", "ConcreteStructs", "DiffEqBase", "LineSearch", "MaybeInplace", "NonlinearSolveBase", "PrecompileTools", "Reexport", "SciMLBase"]
git-tree-sha1 = "f28b1ab17b5f15eb2b174eaf8813cf17f0b3e6c0"
uuid = "26075421-4e9a-44e1-8bd1-420ed7ad02b2"
version = "1.1.0"
weakdeps = ["ForwardDiff"]

    [deps.NonlinearSolveSpectralMethods.extensions]
    NonlinearSolveSpectralMethodsForwardDiffExt = "ForwardDiff"

[[deps.OffsetArrays]]
git-tree-sha1 = "5e1897147d1ff8d98883cda2be2187dcf57d8f0c"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.15.0"
weakdeps = ["Adapt"]

    [deps.OffsetArrays.extensions]
    OffsetArraysAdaptExt = "Adapt"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+4"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "a9697f1d06cc3eb3fb3ad49cc67f2cfabaac31ea"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.16+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "1346c9208249809840c91b26703912dff463d335"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.6+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6703a85cb3781bd5909d48730a67205f3f31a575"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.3+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "cc4054e898b852042d7b503313f7ad03de99c3dd"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.8.0"

[[deps.OrdinaryDiffEq]]
deps = ["ADTypes", "Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DocStringExtensions", "EnumX", "ExponentialUtilities", "FastBroadcast", "FastClosures", "FillArrays", "FiniteDiff", "ForwardDiff", "FunctionWrappersWrappers", "InteractiveUtils", "LineSearches", "LinearAlgebra", "LinearSolve", "Logging", "MacroTools", "MuladdMacro", "NonlinearSolve", "OrdinaryDiffEqAdamsBashforthMoulton", "OrdinaryDiffEqBDF", "OrdinaryDiffEqCore", "OrdinaryDiffEqDefault", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqExplicitRK", "OrdinaryDiffEqExponentialRK", "OrdinaryDiffEqExtrapolation", "OrdinaryDiffEqFIRK", "OrdinaryDiffEqFeagin", "OrdinaryDiffEqFunctionMap", "OrdinaryDiffEqHighOrderRK", "OrdinaryDiffEqIMEXMultistep", "OrdinaryDiffEqLinear", "OrdinaryDiffEqLowOrderRK", "OrdinaryDiffEqLowStorageRK", "OrdinaryDiffEqNonlinearSolve", "OrdinaryDiffEqNordsieck", "OrdinaryDiffEqPDIRK", "OrdinaryDiffEqPRK", "OrdinaryDiffEqQPRK", "OrdinaryDiffEqRKN", "OrdinaryDiffEqRosenbrock", "OrdinaryDiffEqSDIRK", "OrdinaryDiffEqSSPRK", "OrdinaryDiffEqStabilizedIRK", "OrdinaryDiffEqStabilizedRK", "OrdinaryDiffEqSymplecticRK", "OrdinaryDiffEqTsit5", "OrdinaryDiffEqVerner", "Polyester", "PreallocationTools", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLOperators", "SciMLStructures", "SimpleNonlinearSolve", "SimpleUnPack", "SparseArrays", "SparseDiffTools", "Static", "StaticArrayInterface", "StaticArrays", "TruncatedStacktraces"]
git-tree-sha1 = "36ce9bfc14a4b3dcf1490e80b5f1f4d35bfddf39"
uuid = "1dea7af3-3e70-54e6-95c3-0bf5283fa5ed"
version = "6.90.1"

[[deps.OrdinaryDiffEqAdamsBashforthMoulton]]
deps = ["ADTypes", "DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqLowOrderRK", "Polyester", "RecursiveArrayTools", "Reexport", "Static"]
git-tree-sha1 = "8e3c5978d0531a961f70d2f2730d1d16ed3bbd12"
uuid = "89bda076-bce5-4f1c-845f-551c83cdda9a"
version = "1.1.0"

[[deps.OrdinaryDiffEqBDF]]
deps = ["ADTypes", "ArrayInterface", "DiffEqBase", "FastBroadcast", "LinearAlgebra", "MacroTools", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqNonlinearSolve", "OrdinaryDiffEqSDIRK", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "StaticArrays", "TruncatedStacktraces"]
git-tree-sha1 = "86ccea2bd0fdfa5570172a9717061f6417e21dea"
uuid = "6ad6398a-0878-4a85-9266-38940aa047c8"
version = "1.2.0"

[[deps.OrdinaryDiffEqCore]]
deps = ["ADTypes", "Accessors", "Adapt", "ArrayInterface", "DataStructures", "DiffEqBase", "DocStringExtensions", "EnumX", "FastBroadcast", "FastClosures", "FastPower", "FillArrays", "FunctionWrappersWrappers", "InteractiveUtils", "LinearAlgebra", "Logging", "MacroTools", "MuladdMacro", "Polyester", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLOperators", "SciMLStructures", "SimpleUnPack", "Static", "StaticArrayInterface", "StaticArraysCore", "SymbolicIndexingInterface", "TruncatedStacktraces"]
git-tree-sha1 = "72c77ae685fddb6291fff22dba13f4f32602475c"
uuid = "bbf590c4-e513-4bbe-9b18-05decba2e5d8"
version = "1.14.1"
weakdeps = ["EnzymeCore"]

    [deps.OrdinaryDiffEqCore.extensions]
    OrdinaryDiffEqCoreEnzymeCoreExt = "EnzymeCore"

[[deps.OrdinaryDiffEqDefault]]
deps = ["ADTypes", "DiffEqBase", "EnumX", "LinearAlgebra", "LinearSolve", "OrdinaryDiffEqBDF", "OrdinaryDiffEqCore", "OrdinaryDiffEqRosenbrock", "OrdinaryDiffEqTsit5", "OrdinaryDiffEqVerner", "PrecompileTools", "Preferences", "Reexport"]
git-tree-sha1 = "2ee6ef0bbed24976e4acfccf609801f8a5bf8223"
uuid = "50262376-6c5a-4cf5-baba-aaf4f84d72d7"
version = "1.2.0"

[[deps.OrdinaryDiffEqDifferentiation]]
deps = ["ADTypes", "ArrayInterface", "DiffEqBase", "FastBroadcast", "FiniteDiff", "ForwardDiff", "FunctionWrappersWrappers", "LinearAlgebra", "LinearSolve", "OrdinaryDiffEqCore", "SciMLBase", "SparseArrays", "SparseDiffTools", "StaticArrayInterface", "StaticArrays"]
git-tree-sha1 = "e4adff09a6d47b74c16e7e08f10fa32000e2e5ed"
uuid = "4302a76b-040a-498a-8c04-15b101fed76b"
version = "1.3.0"

[[deps.OrdinaryDiffEqExplicitRK]]
deps = ["DiffEqBase", "FastBroadcast", "LinearAlgebra", "MuladdMacro", "OrdinaryDiffEqCore", "RecursiveArrayTools", "Reexport", "TruncatedStacktraces"]
git-tree-sha1 = "4dbce3f9e6974567082ce5176e21aab0224a69e9"
uuid = "9286f039-9fbf-40e8-bf65-aa933bdc4db0"
version = "1.1.0"

[[deps.OrdinaryDiffEqExponentialRK]]
deps = ["ADTypes", "DiffEqBase", "ExponentialUtilities", "FastBroadcast", "LinearAlgebra", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqSDIRK", "OrdinaryDiffEqVerner", "RecursiveArrayTools", "Reexport", "SciMLBase"]
git-tree-sha1 = "8659d5fdfe0798bbb5bcd8dc8d08092744b6dfa4"
uuid = "e0540318-69ee-4070-8777-9e2de6de23de"
version = "1.2.0"

[[deps.OrdinaryDiffEqExtrapolation]]
deps = ["ADTypes", "DiffEqBase", "FastBroadcast", "FastPower", "LinearSolve", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "Polyester", "RecursiveArrayTools", "Reexport"]
git-tree-sha1 = "b8d852b23246b1427178520442e8e7d89aa1c64c"
uuid = "becaefa8-8ca2-5cf9-886d-c06f3d2bd2c4"
version = "1.3.0"

[[deps.OrdinaryDiffEqFIRK]]
deps = ["ADTypes", "DiffEqBase", "FastBroadcast", "FastGaussQuadrature", "FastPower", "LinearAlgebra", "LinearSolve", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqNonlinearSolve", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLOperators"]
git-tree-sha1 = "39a52e278e21018585fc02c04a54f0ab98d03369"
uuid = "5960d6e9-dd7a-4743-88e7-cf307b64f125"
version = "1.6.0"

[[deps.OrdinaryDiffEqFeagin]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "Polyester", "RecursiveArrayTools", "Reexport", "Static"]
git-tree-sha1 = "a7cc74d3433db98e59dc3d58bc28174c6c290adf"
uuid = "101fe9f7-ebb6-4678-b671-3a81e7194747"
version = "1.1.0"

[[deps.OrdinaryDiffEqFunctionMap]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "RecursiveArrayTools", "Reexport", "SciMLBase", "Static"]
git-tree-sha1 = "925a91583d1ab84f1f0fea121be1abf1179c5926"
uuid = "d3585ca7-f5d3-4ba6-8057-292ed1abd90f"
version = "1.1.1"

[[deps.OrdinaryDiffEqHighOrderRK]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "RecursiveArrayTools", "Reexport", "Static"]
git-tree-sha1 = "103e017ff186ac39d731904045781c9bacfca2b0"
uuid = "d28bc4f8-55e1-4f49-af69-84c1a99f0f58"
version = "1.1.0"

[[deps.OrdinaryDiffEqIMEXMultistep]]
deps = ["ADTypes", "DiffEqBase", "FastBroadcast", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqNonlinearSolve", "Reexport"]
git-tree-sha1 = "b35b6db127ad50bc502f72dbd5a84a1e1d1bbf01"
uuid = "9f002381-b378-40b7-97a6-27a27c83f129"
version = "1.2.0"

[[deps.OrdinaryDiffEqLinear]]
deps = ["DiffEqBase", "ExponentialUtilities", "LinearAlgebra", "OrdinaryDiffEqCore", "OrdinaryDiffEqTsit5", "OrdinaryDiffEqVerner", "RecursiveArrayTools", "Reexport", "SciMLBase", "SciMLOperators"]
git-tree-sha1 = "0f81a77ede3da0dc714ea61e81c76b25db4ab87a"
uuid = "521117fe-8c41-49f8-b3b6-30780b3f0fb5"
version = "1.1.0"

[[deps.OrdinaryDiffEqLowOrderRK]]
deps = ["DiffEqBase", "FastBroadcast", "LinearAlgebra", "MuladdMacro", "OrdinaryDiffEqCore", "RecursiveArrayTools", "Reexport", "SciMLBase", "Static"]
git-tree-sha1 = "d4bb32e09d6b68ce2eb45fb81001eab46f60717a"
uuid = "1344f307-1e59-4825-a18e-ace9aa3fa4c6"
version = "1.2.0"

[[deps.OrdinaryDiffEqLowStorageRK]]
deps = ["Adapt", "DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "Polyester", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "Static", "StaticArrays"]
git-tree-sha1 = "590561f3af623d5485d070b4d7044f8854535f5a"
uuid = "b0944070-b475-4768-8dec-fb6eb410534d"
version = "1.2.1"

[[deps.OrdinaryDiffEqNonlinearSolve]]
deps = ["ADTypes", "ArrayInterface", "DiffEqBase", "FastBroadcast", "FastClosures", "ForwardDiff", "LinearAlgebra", "LinearSolve", "MuladdMacro", "NonlinearSolve", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "PreallocationTools", "RecursiveArrayTools", "SciMLBase", "SciMLOperators", "SciMLStructures", "SimpleNonlinearSolve", "StaticArrays"]
git-tree-sha1 = "3a3eb0b7ef3f996c468d6f8013eac9525bcfd788"
uuid = "127b3ac7-2247-4354-8eb6-78cf4e7c58e8"
version = "1.3.0"

[[deps.OrdinaryDiffEqNordsieck]]
deps = ["DiffEqBase", "FastBroadcast", "LinearAlgebra", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqTsit5", "Polyester", "RecursiveArrayTools", "Reexport", "Static"]
git-tree-sha1 = "ef44754f10e0dfb9bb55ded382afed44cd94ab57"
uuid = "c9986a66-5c92-4813-8696-a7ec84c806c8"
version = "1.1.0"

[[deps.OrdinaryDiffEqPDIRK]]
deps = ["ADTypes", "DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqNonlinearSolve", "Polyester", "Reexport", "StaticArrays"]
git-tree-sha1 = "70e348c116ce62df4e4b4f90f3c8bb4a8164df31"
uuid = "5dd0a6cf-3d4b-4314-aa06-06d4e299bc89"
version = "1.2.0"

[[deps.OrdinaryDiffEqPRK]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "Polyester", "Reexport"]
git-tree-sha1 = "da525d277962a1b76102c79f30cb0c31e13fe5b9"
uuid = "5b33eab2-c0f1-4480-b2c3-94bc1e80bda1"
version = "1.1.0"

[[deps.OrdinaryDiffEqQPRK]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "RecursiveArrayTools", "Reexport", "Static"]
git-tree-sha1 = "332f9d17d0229218f66a73492162267359ba85e9"
uuid = "04162be5-8125-4266-98ed-640baecc6514"
version = "1.1.0"

[[deps.OrdinaryDiffEqRKN]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "Polyester", "RecursiveArrayTools", "Reexport"]
git-tree-sha1 = "41c09d9c20877546490f907d8dffdd52690dd65f"
uuid = "af6ede74-add8-4cfd-b1df-9a4dbb109d7a"
version = "1.1.0"

[[deps.OrdinaryDiffEqRosenbrock]]
deps = ["ADTypes", "DiffEqBase", "FastBroadcast", "FiniteDiff", "ForwardDiff", "LinearAlgebra", "LinearSolve", "MacroTools", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "Polyester", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "Static"]
git-tree-sha1 = "749518f27e886164ee07e6df49b631beaca8c9ac"
uuid = "43230ef6-c299-4910-a778-202eb28ce4ce"
version = "1.4.0"

[[deps.OrdinaryDiffEqSDIRK]]
deps = ["ADTypes", "DiffEqBase", "FastBroadcast", "LinearAlgebra", "MacroTools", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqNonlinearSolve", "RecursiveArrayTools", "Reexport", "SciMLBase", "TruncatedStacktraces"]
git-tree-sha1 = "45eed1444fbfa510e1806d4153f83bd862d2d035"
uuid = "2d112036-d095-4a1e-ab9a-08536f3ecdbf"
version = "1.2.0"

[[deps.OrdinaryDiffEqSSPRK]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "Polyester", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "Static", "StaticArrays"]
git-tree-sha1 = "7dbe4ac56f930df5e9abd003cedb54e25cbbea86"
uuid = "669c94d9-1f4b-4b64-b377-1aa079aa2388"
version = "1.2.0"

[[deps.OrdinaryDiffEqStabilizedIRK]]
deps = ["ADTypes", "DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "OrdinaryDiffEqDifferentiation", "OrdinaryDiffEqNonlinearSolve", "RecursiveArrayTools", "Reexport", "StaticArrays"]
git-tree-sha1 = "f2533f086540db6eb3a5eddbecf963cbc4ab6015"
uuid = "e3e12d00-db14-5390-b879-ac3dd2ef6296"
version = "1.2.0"

[[deps.OrdinaryDiffEqStabilizedRK]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "RecursiveArrayTools", "Reexport", "StaticArrays"]
git-tree-sha1 = "1b0d894c880e25f7d0b022d7257638cf8ce5b311"
uuid = "358294b1-0aab-51c3-aafe-ad5ab194a2ad"
version = "1.1.0"

[[deps.OrdinaryDiffEqSymplecticRK]]
deps = ["DiffEqBase", "FastBroadcast", "MuladdMacro", "OrdinaryDiffEqCore", "Polyester", "RecursiveArrayTools", "Reexport"]
git-tree-sha1 = "4e8b8c8b81df3df17e2eb4603115db3b30a88235"
uuid = "fa646aed-7ef9-47eb-84c4-9443fc8cbfa8"
version = "1.1.0"

[[deps.OrdinaryDiffEqTsit5]]
deps = ["DiffEqBase", "FastBroadcast", "LinearAlgebra", "MuladdMacro", "OrdinaryDiffEqCore", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "Static", "TruncatedStacktraces"]
git-tree-sha1 = "96552f7d4619fabab4038a29ed37dd55e9eb513a"
uuid = "b1df2697-797e-41e3-8120-5422d3b24e4a"
version = "1.1.0"

[[deps.OrdinaryDiffEqVerner]]
deps = ["DiffEqBase", "FastBroadcast", "LinearAlgebra", "MuladdMacro", "OrdinaryDiffEqCore", "Polyester", "PrecompileTools", "Preferences", "RecursiveArrayTools", "Reexport", "Static", "TruncatedStacktraces"]
git-tree-sha1 = "81d7841e73e385b9925d5c8e4427f2adcdda55db"
uuid = "79d7bb75-1356-48c1-b8c0-6832512096c2"
version = "1.1.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.PackageExtensionCompat]]
git-tree-sha1 = "fb28e33b8a95c4cee25ce296c817d89cc2e53518"
uuid = "65ce6f38-6b18-4e1d-a461-8949797d7930"
version = "1.0.2"
weakdeps = ["Requires", "TOML"]

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "3b31172c032a1def20c98dae3f2cdc9d10e3b561"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.56.1+0"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "8489905bcdbcfac64d1daa51ca07c0d8f0283821"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.1"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LLVMOpenMP_jll", "Libdl"]
git-tree-sha1 = "35621f10a7531bc8fa58f74610b1bfb70a3cfc6b"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.43.4+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "41031ef3a1be6f5bbbf3e8073f210556daeae5ca"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.3.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "PrecompileTools", "Printf", "Random", "Reexport", "StableRNGs", "Statistics"]
git-tree-sha1 = "3ca9a356cd2e113c420f2c13bea19f8d3fb1cb18"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.4.3"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "PrecompileTools", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "TOML", "UUIDs", "UnicodeFun", "UnitfulLatexify", "Unzip"]
git-tree-sha1 = "dae01f8c2e069a683d3a6e17bbae5070ab94786f"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.40.9"

    [deps.Plots.extensions]
    FileIOExt = "FileIO"
    GeometryBasicsExt = "GeometryBasics"
    IJuliaExt = "IJulia"
    ImageInTerminalExt = "ImageInTerminal"
    UnitfulExt = "Unitful"

    [deps.Plots.weakdeps]
    FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
    GeometryBasics = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
    IJulia = "7073ff75-c697-5162-941a-fcdaad2a7d2a"
    ImageInTerminal = "d8c32880-2388-543b-8c61-d9f865259254"
    Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "7e71a55b87222942f0f9337be62e26b1f103d3e4"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.61"

[[deps.Polyester]]
deps = ["ArrayInterface", "BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "ManualMemory", "PolyesterWeave", "Static", "StaticArrayInterface", "StrideArraysCore", "ThreadingUtilities"]
git-tree-sha1 = "6d38fea02d983051776a856b7df75b30cf9a3c1f"
uuid = "f517fe37-dbe3-4b94-8317-1923a5111588"
version = "0.7.16"

[[deps.PolyesterWeave]]
deps = ["BitTwiddlingConvenienceFunctions", "CPUSummary", "IfElse", "Static", "ThreadingUtilities"]
git-tree-sha1 = "645bed98cd47f72f67316fd42fc47dee771aefcd"
uuid = "1d0040c9-8b98-4ee7-8388-3f51789ca0ad"
version = "0.2.2"

[[deps.PreallocationTools]]
deps = ["Adapt", "ArrayInterface", "ForwardDiff"]
git-tree-sha1 = "6c62ce45f268f3f958821a1e5192cf91c75ae89c"
uuid = "d236fae5-4411-538c-8e31-a6e3d9e00b46"
version = "0.4.24"

    [deps.PreallocationTools.extensions]
    PreallocationToolsReverseDiffExt = "ReverseDiff"

    [deps.PreallocationTools.weakdeps]
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.PtrArrays]]
git-tree-sha1 = "1d36ef11a9aaf1e8b74dacc6a731dd1de8fd493d"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.3.0"

[[deps.Qt6Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Vulkan_Loader_jll", "Xorg_libSM_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_cursor_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "libinput_jll", "xkbcommon_jll"]
git-tree-sha1 = "492601870742dcd38f233b23c3ec629628c1d724"
uuid = "c0090381-4147-56d7-9ebc-da0b1113ec56"
version = "6.7.1+1"

[[deps.Qt6Declarative_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6ShaderTools_jll"]
git-tree-sha1 = "e5dd466bf2569fe08c91a2cc29c1003f4797ac3b"
uuid = "629bc702-f1f5-5709-abd5-49b8460ea067"
version = "6.7.1+2"

[[deps.Qt6ShaderTools_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll"]
git-tree-sha1 = "1a180aeced866700d4bebc3120ea1451201f16bc"
uuid = "ce943373-25bb-56aa-8eca-768745ed7b5a"
version = "6.7.1+1"

[[deps.Qt6Wayland_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Qt6Base_jll", "Qt6Declarative_jll"]
git-tree-sha1 = "729927532d48cf79f49070341e1d918a65aba6b0"
uuid = "e99dba38-086e-5de3-a5b1-6e4c66e897c3"
version = "6.7.1+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["PrecompileTools"]
git-tree-sha1 = "5c3d09cc4f31f5fc6af001c250bf1278733100ff"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.4"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "PrecompileTools", "RecipesBase"]
git-tree-sha1 = "45cf9fd0ca5839d06ef333c8201714e888486342"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.12"

[[deps.RecursiveArrayTools]]
deps = ["Adapt", "ArrayInterface", "DocStringExtensions", "GPUArraysCore", "IteratorInterfaceExtensions", "LinearAlgebra", "RecipesBase", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface", "Tables"]
git-tree-sha1 = "32f824db4e5bab64e25a12b22483a30a6b813d08"
uuid = "731186ca-8d62-57ce-b412-fbd966d074cd"
version = "3.27.4"

    [deps.RecursiveArrayTools.extensions]
    RecursiveArrayToolsFastBroadcastExt = "FastBroadcast"
    RecursiveArrayToolsForwardDiffExt = "ForwardDiff"
    RecursiveArrayToolsMeasurementsExt = "Measurements"
    RecursiveArrayToolsMonteCarloMeasurementsExt = "MonteCarloMeasurements"
    RecursiveArrayToolsReverseDiffExt = ["ReverseDiff", "Zygote"]
    RecursiveArrayToolsSparseArraysExt = ["SparseArrays"]
    RecursiveArrayToolsStructArraysExt = "StructArrays"
    RecursiveArrayToolsTrackerExt = "Tracker"
    RecursiveArrayToolsZygoteExt = "Zygote"

    [deps.RecursiveArrayTools.weakdeps]
    FastBroadcast = "7034ab61-46d4-4ed7-9d0f-46aef9175898"
    ForwardDiff = "f6369f11-7733-5829-9624-2563aa707210"
    Measurements = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
    MonteCarloMeasurements = "0987c9cc-fe09-11e8-30f0-b96dd679fdca"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.RecursiveFactorization]]
deps = ["LinearAlgebra", "LoopVectorization", "Polyester", "PrecompileTools", "StrideArraysCore", "TriangularSolve"]
git-tree-sha1 = "6db1a75507051bc18bfa131fbc7c3f169cc4b2f6"
uuid = "f2c3362d-daeb-58d1-803e-2bc74f2840b4"
version = "0.2.23"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "ffdaf70d81cf6ff22c2b6e733c900c3321cab864"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.1"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "62389eeff14780bfe55195b7204c0d8738436d64"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.1"

[[deps.RuntimeGeneratedFunctions]]
deps = ["ExprTools", "SHA", "Serialization"]
git-tree-sha1 = "04c968137612c4a5629fa531334bb81ad5680f00"
uuid = "7e49a35a-f44a-4d26-94aa-eba1b4ca6b47"
version = "0.5.13"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.SIMDTypes]]
git-tree-sha1 = "330289636fb8107c5f32088d2741e9fd7a061a5c"
uuid = "94e857df-77ce-4151-89e5-788b33177be4"
version = "0.1.0"

[[deps.SLEEFPirates]]
deps = ["IfElse", "Static", "VectorizationBase"]
git-tree-sha1 = "456f610ca2fbd1c14f5fcf31c6bfadc55e7d66e0"
uuid = "476501e8-09a2-5ece-8869-fb82de89a1fa"
version = "0.6.43"

[[deps.SciMLBase]]
deps = ["ADTypes", "Accessors", "ArrayInterface", "CommonSolve", "ConstructionBase", "Distributed", "DocStringExtensions", "EnumX", "Expronicon", "FunctionWrappersWrappers", "IteratorInterfaceExtensions", "LinearAlgebra", "Logging", "Markdown", "PrecompileTools", "Preferences", "Printf", "RecipesBase", "RecursiveArrayTools", "Reexport", "RuntimeGeneratedFunctions", "SciMLOperators", "SciMLStructures", "StaticArraysCore", "Statistics", "SymbolicIndexingInterface"]
git-tree-sha1 = "3e5a9c5d6432b77a271646b4ada2573f239ac5c4"
uuid = "0bca4576-84f4-4d90-8ffe-ffa030f20462"
version = "2.70.0"

    [deps.SciMLBase.extensions]
    SciMLBaseChainRulesCoreExt = "ChainRulesCore"
    SciMLBaseMakieExt = "Makie"
    SciMLBasePartialFunctionsExt = "PartialFunctions"
    SciMLBasePyCallExt = "PyCall"
    SciMLBasePythonCallExt = "PythonCall"
    SciMLBaseRCallExt = "RCall"
    SciMLBaseZygoteExt = "Zygote"

    [deps.SciMLBase.weakdeps]
    ChainRules = "082447d4-558c-5d27-93f4-14fc19e9eca2"
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    Makie = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a"
    PartialFunctions = "570af359-4316-4cb7-8c74-252c00c2016b"
    PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
    PythonCall = "6099a3de-0909-46bc-b1f4-468b9a2dfc0d"
    RCall = "6f49c342-dc21-5d91-9882-a32aef131414"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.SciMLJacobianOperators]]
deps = ["ADTypes", "ArrayInterface", "ConcreteStructs", "ConstructionBase", "DifferentiationInterface", "FastClosures", "LinearAlgebra", "SciMLBase", "SciMLOperators"]
git-tree-sha1 = "f66048bb969e67bd7d1bdd03cd0b81219642bbd0"
uuid = "19f34311-ddf3-4b8b-af20-060888a46c0e"
version = "0.1.1"

[[deps.SciMLOperators]]
deps = ["Accessors", "ArrayInterface", "DocStringExtensions", "LinearAlgebra", "MacroTools"]
git-tree-sha1 = "6149620767866d4b0f0f7028639b6e661b6a1e44"
uuid = "c0aeaf25-5076-4817-a8d5-81caf7dfa961"
version = "0.3.12"
weakdeps = ["SparseArrays", "StaticArraysCore"]

    [deps.SciMLOperators.extensions]
    SciMLOperatorsSparseArraysExt = "SparseArrays"
    SciMLOperatorsStaticArraysCoreExt = "StaticArraysCore"

[[deps.SciMLStructures]]
deps = ["ArrayInterface"]
git-tree-sha1 = "0444a37a25fab98adbd90baa806ee492a3af133a"
uuid = "53ae85a6-f571-4167-b2af-e1d143709226"
version = "1.6.1"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "f305871d2f381d21527c770d4788c06c097c9bc1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.2.0"

[[deps.SimpleNonlinearSolve]]
deps = ["ADTypes", "ArrayInterface", "BracketingNonlinearSolve", "CommonSolve", "ConcreteStructs", "DifferentiationInterface", "FastClosures", "FiniteDiff", "ForwardDiff", "LineSearch", "LinearAlgebra", "MaybeInplace", "NonlinearSolveBase", "PrecompileTools", "Reexport", "SciMLBase", "Setfield", "StaticArraysCore"]
git-tree-sha1 = "a3868a6add9f5989d1f4bd21de0333ef89fb9d9f"
uuid = "727e6d20-b764-4bd8-a329-72de5adea6c7"
version = "2.1.0"

    [deps.SimpleNonlinearSolve.extensions]
    SimpleNonlinearSolveChainRulesCoreExt = "ChainRulesCore"
    SimpleNonlinearSolveDiffEqBaseExt = "DiffEqBase"
    SimpleNonlinearSolveReverseDiffExt = "ReverseDiff"
    SimpleNonlinearSolveTrackerExt = "Tracker"

    [deps.SimpleNonlinearSolve.weakdeps]
    ChainRulesCore = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
    DiffEqBase = "2b5f629d-d688-5b77-993f-72d75c75574e"
    ReverseDiff = "37e2e3b7-166d-5795-8a7a-e32c996b4267"
    Tracker = "9f7883ad-71c0-57eb-9f7f-b5c9e6d3789c"

[[deps.SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[deps.SimpleUnPack]]
git-tree-sha1 = "58e6353e72cde29b90a69527e56df1b5c3d8c437"
uuid = "ce78b400-467f-4804-87d8-8f486da07d0a"
version = "1.1.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "66e0a8e672a0bdfca2c3f5937efb8538b9ddc085"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.2.1"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.SparseDiffTools]]
deps = ["ADTypes", "Adapt", "ArrayInterface", "Compat", "DataStructures", "FiniteDiff", "ForwardDiff", "Graphs", "LinearAlgebra", "PackageExtensionCompat", "Random", "Reexport", "SciMLOperators", "Setfield", "SparseArrays", "StaticArrayInterface", "StaticArrays", "UnPack", "VertexSafeGraphs"]
git-tree-sha1 = "d79802152d958607f414f5447cb25e314db979c0"
uuid = "47a9eef4-7e08-11e9-0b38-333d64bd3804"
version = "2.23.1"

    [deps.SparseDiffTools.extensions]
    SparseDiffToolsEnzymeExt = "Enzyme"
    SparseDiffToolsPolyesterExt = "Polyester"
    SparseDiffToolsPolyesterForwardDiffExt = "PolyesterForwardDiff"
    SparseDiffToolsSymbolicsExt = "Symbolics"
    SparseDiffToolsZygoteExt = "Zygote"

    [deps.SparseDiffTools.weakdeps]
    Enzyme = "7da242da-08ed-463a-9acd-ee780be4f1d9"
    Polyester = "f517fe37-dbe3-4b94-8317-1923a5111588"
    PolyesterForwardDiff = "98d1487c-24ca-40b6-b7ab-df2af84e126b"
    Symbolics = "0c5d862f-8b57-4792-8d23-62f2024744c7"
    Zygote = "e88e6eb3-aa80-5325-afca-941959d7151f"

[[deps.SparseMatrixColorings]]
deps = ["ADTypes", "DataStructures", "DocStringExtensions", "LinearAlgebra", "Random", "SparseArrays"]
git-tree-sha1 = "76b44c879661552d64f382acf66faa29ab56b3d9"
uuid = "0a514795-09f3-496d-8182-132a7b665d35"
version = "0.4.10"
weakdeps = ["Colors"]

    [deps.SparseMatrixColorings.extensions]
    SparseMatrixColoringsColorsExt = "Colors"

[[deps.Sparspak]]
deps = ["Libdl", "LinearAlgebra", "Logging", "OffsetArrays", "Printf", "SparseArrays", "Test"]
git-tree-sha1 = "342cf4b449c299d8d1ceaf00b7a49f4fbc7940e7"
uuid = "e56a9233-b9d6-4f03-8d0f-1825330902ac"
version = "0.3.9"

[[deps.SpecialFunctions]]
deps = ["IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "64cca0c26b4f31ba18f13f6c12af7c85f478cfde"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.5.0"
weakdeps = ["ChainRulesCore"]

    [deps.SpecialFunctions.extensions]
    SpecialFunctionsChainRulesCoreExt = "ChainRulesCore"

[[deps.StableRNGs]]
deps = ["Random"]
git-tree-sha1 = "83e6cce8324d49dfaf9ef059227f91ed4441a8e5"
uuid = "860ef19b-820b-49d6-a774-d7a799459cd3"
version = "1.0.2"

[[deps.Static]]
deps = ["CommonWorldInvalidations", "IfElse", "PrecompileTools"]
git-tree-sha1 = "87d51a3ee9a4b0d2fe054bdd3fc2436258db2603"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "1.1.1"

[[deps.StaticArrayInterface]]
deps = ["ArrayInterface", "Compat", "IfElse", "LinearAlgebra", "PrecompileTools", "Static"]
git-tree-sha1 = "96381d50f1ce85f2663584c8e886a6ca97e60554"
uuid = "0d7ed370-da01-4f52-bd93-41d350b8b718"
version = "1.8.0"
weakdeps = ["OffsetArrays", "StaticArrays"]

    [deps.StaticArrayInterface.extensions]
    StaticArrayInterfaceOffsetArraysExt = "OffsetArrays"
    StaticArrayInterfaceStaticArraysExt = "StaticArrays"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "0feb6b9031bd5c51f9072393eb5ab3efd31bf9e4"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.9.13"
weakdeps = ["ChainRulesCore", "Statistics"]

    [deps.StaticArrays.extensions]
    StaticArraysChainRulesCoreExt = "ChainRulesCore"
    StaticArraysStatisticsExt = "Statistics"

[[deps.StaticArraysCore]]
git-tree-sha1 = "192954ef1208c7019899fbf8049e717f92959682"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.3"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1ff449ad350c9c4cbc756624d6f8a8c3ef56d3ed"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.7.0"

[[deps.StatsBase]]
deps = ["AliasTables", "DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "29321314c920c26684834965ec2ce0dacc9cf8e5"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.34.4"

[[deps.StrideArraysCore]]
deps = ["ArrayInterface", "CloseOpenIntervals", "IfElse", "LayoutPointers", "LinearAlgebra", "ManualMemory", "SIMDTypes", "Static", "StaticArrayInterface", "ThreadingUtilities"]
git-tree-sha1 = "f35f6ab602df8413a50c4a25ca14de821e8605fb"
uuid = "7792a7ef-975c-4747-a70f-980b88e8d1da"
version = "0.5.7"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.SymbolicIndexingInterface]]
deps = ["Accessors", "ArrayInterface", "RuntimeGeneratedFunctions", "StaticArraysCore"]
git-tree-sha1 = "fd2d4f0499f6bb4a0d9f5030f5c7d61eed385e03"
uuid = "2efcf032-c050-4f8e-a9bb-153293bab1f5"
version = "0.3.37"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "OrderedCollections", "TableTraits"]
git-tree-sha1 = "598cd7c1f68d1e205689b1c2fe65a9f85846f297"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.12.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.ThreadingUtilities]]
deps = ["ManualMemory"]
git-tree-sha1 = "eda08f7e9818eb53661b3deb74e3159460dfbc27"
uuid = "8290d209-cae3-49c0-8002-c8c24d57dab5"
version = "0.5.2"

[[deps.TimerOutputs]]
deps = ["ExprTools", "Printf"]
git-tree-sha1 = "d7298ebdfa1654583468a487e8e83fae9d72dac3"
uuid = "a759f4b9-e2f1-59dc-863e-4aeb61b1ea8f"
version = "0.5.26"

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[deps.TriangularSolve]]
deps = ["CloseOpenIntervals", "IfElse", "LayoutPointers", "LinearAlgebra", "LoopVectorization", "Polyester", "Static", "VectorizationBase"]
git-tree-sha1 = "be986ad9dac14888ba338c2554dcfec6939e1393"
uuid = "d5829a12-d9aa-46ab-831f-fb7c9ab06edf"
version = "0.2.1"

[[deps.Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"

[[deps.TruncatedStacktraces]]
deps = ["InteractiveUtils", "MacroTools", "Preferences"]
git-tree-sha1 = "ea3e54c2bdde39062abf5a9758a23735558705e1"
uuid = "781d530d-4396-4725-bb49-402e4bee1e77"
version = "1.4.0"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "c0667a8e676c53d390a09dc6870b3d8d6650e2bf"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.22.0"
weakdeps = ["ConstructionBase", "InverseFunctions"]

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "975c354fcd5f7e1ddcc1f1a23e6e091d99e99bc8"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.4"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.VectorizationBase]]
deps = ["ArrayInterface", "CPUSummary", "HostCPUFeatures", "IfElse", "LayoutPointers", "Libdl", "LinearAlgebra", "SIMDTypes", "Static", "StaticArrayInterface"]
git-tree-sha1 = "4ab62a49f1d8d9548a1c8d1a75e5f55cf196f64e"
uuid = "3d5dd08c-fd9d-11e8-17fa-ed2836048c2f"
version = "0.21.71"

[[deps.VertexSafeGraphs]]
deps = ["Graphs"]
git-tree-sha1 = "8351f8d73d7e880bfc042a8b6922684ebeafb35c"
uuid = "19fa3120-7c27-5ec5-8db8-b0b0aa330d6f"
version = "0.2.0"

[[deps.Vulkan_Loader_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Wayland_jll", "Xorg_libX11_jll", "Xorg_libXrandr_jll", "xkbcommon_jll"]
git-tree-sha1 = "2f0486047a07670caad3a81a075d2e518acc5c59"
uuid = "a44049a8-05dd-5a78-86c9-5fde0876e88c"
version = "1.3.243+0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "EpollShim_jll", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "85c7811eddec9e7f22615371c3cc81a504c508ee"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+2"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "5db3e9d307d32baba7067b13fc7b5aa6edd4a19a"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.36.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Zlib_jll"]
git-tree-sha1 = "b8b243e47228b4a3877f1dd6aee0c5d56db7fcf4"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.13.6+1"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "7d1671acbe47ac88e981868a078bd6b4e27c5191"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.42+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "56c6604ec8b2d82cc4cfe01aa03b00426aac7e1f"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.6.4+1"

[[deps.Xorg_libICE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "326b4fea307b0b39892b3e85fa451692eda8d46c"
uuid = "f67eecfb-183a-506d-b269-f58e52b52d7c"
version = "1.1.1+0"

[[deps.Xorg_libSM_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libICE_jll"]
git-tree-sha1 = "3796722887072218eabafb494a13c963209754ce"
uuid = "c834827a-8449-5923-a945-d239c165b7dd"
version = "1.2.4+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "9dafcee1d24c4f024e7edc92603cedba72118283"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.8.6+3"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "e9216fdcd8514b7072b43653874fd688e4c6c003"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.12+0"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "807c226eaf3651e7b2c468f687ac788291f9a89b"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.3+0"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "89799ae67c17caa5b3b5a19b8469eeee474377db"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.5+0"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "d7155fea91a4123ef59f42c4afb5ab3b4ca95058"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.6+3"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "6fcc21d5aea1a0b7cce6cab3e62246abd1949b86"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "6.0.0+0"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "984b313b049c89739075b8e2a94407076de17449"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.8.2+0"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll"]
git-tree-sha1 = "a1a7eaf6c3b5b05cb903e35e8372049b107ac729"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.5+0"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "b6f664b7b2f6a39689d822a6300b14df4668f0f4"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.4+0"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "a490c6212a0e90d2d55111ac956f7c4fa9c277a6"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.11+1"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "c57201109a9e4c0585b208bb408bc41d205ac4e9"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.2+0"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "1a74296303b6524a0472a8cb12d3d87a78eb3612"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.17.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libX11_jll"]
git-tree-sha1 = "dbc53e4cf7701c6c7047c51e17d6e64df55dca94"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.2+1"

[[deps.Xorg_xcb_util_cursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_jll", "Xorg_xcb_util_renderutil_jll"]
git-tree-sha1 = "04341cb870f29dcd5e39055f895c39d016e18ccd"
uuid = "e920d4aa-a673-5f3a-b3d7-f755a4d47c43"
version = "0.1.4+0"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "ab2221d309eda71020cdda67a973aa582aa85d69"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.6+1"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "691634e5453ad362044e2ad653e79f3ee3bb98c3"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.39.0+0"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6dba04dbfb72ae3ebe5418ba33d087ba8aa8cb00"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.1+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "446b23e73536f84e8037f5dce465e92275f6a308"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.7+1"

[[deps.eudev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "gperf_jll"]
git-tree-sha1 = "431b678a28ebb559d224c0b6b6d01afce87c51ba"
uuid = "35ca27e7-8b34-5b7f-bca9-bdc33f59eb06"
version = "3.2.9+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6e50f145003024df4f5cb96c7fce79466741d601"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.56.3+0"

[[deps.gperf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0ba42241cb6809f1a278d0bcb976e0483c3f1f2d"
uuid = "1a1c6b14-54f6-533d-8383-74cd7377aa70"
version = "3.1.1+1"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "522c1df09d05a71785765d19c9524661234738e9"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.11.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "e17c115d55c5fbb7e52ebedb427a0dca79d4484e"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.2+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.libdecor_jll]]
deps = ["Artifacts", "Dbus_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pango_jll", "Wayland_jll", "xkbcommon_jll"]
git-tree-sha1 = "9bf7903af251d2050b467f76bdbe57ce541f7f4f"
uuid = "1183f4f0-6f2a-5f1a-908b-139f9cdfea6f"
version = "0.2.2+0"

[[deps.libevdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "141fe65dc3efabb0b1d5ba74e91f6ad26f84cc22"
uuid = "2db6ffa8-e38f-5e21-84af-90c45d0032cc"
version = "1.11.0+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "8a22cf860a7d27e4f3498a0fe0811a7957badb38"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.3+0"

[[deps.libinput_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "eudev_jll", "libevdev_jll", "mtdev_jll"]
git-tree-sha1 = "ad50e5b90f222cfe78aa3d5183a20a12de1322ce"
uuid = "36db933b-70db-51c0-b978-0f229ee0e533"
version = "1.18.0+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Zlib_jll"]
git-tree-sha1 = "068dfe202b0a05b8332f1e8e6b4080684b9c7700"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.47+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "490376214c4721cdaca654041f635213c6165cb3"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+2"

[[deps.mtdev_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "814e154bdb7be91d78b6802843f76b6ece642f11"
uuid = "009596ad-96f7-51b1-9f1b-5ce2d5e8a71e"
version = "1.1.6+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.oneTBB_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7d0ea0f4895ef2f5cb83645fa689e52cb55cf493"
uuid = "1317d2d5-d96f-522e-a858-c73665f53c3e"
version = "2021.12.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "63406453ed9b33a0df95d570816d5366c92b7809"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+2"
"""

# ╔═╡ Cell order:
# ╟─a38944d0-fe91-11ef-072f-3ff67937cf8c
# ╟─43f521aa-e221-4682-9a5b-fa9e68b518df
# ╟─ab0dcff5-4fe7-4367-a7db-890616a09b0c
# ╟─a9252508-2366-4e16-964c-526c475456eb
# ╟─32806421-180c-4786-88c5-b89705615f7a
# ╟─814d1578-4044-4688-8a57-22f66ebccae5
# ╟─34527262-3bae-4a12-8652-fa6ea106cfb3
# ╟─5c802857-e0a0-482c-b222-9d0757a4991a
# ╟─b75e2519-a89c-41d3-af1e-ecf765c997a2
# ╟─8231135d-906e-4462-8a57-571054e03553
# ╟─7570b6a9-5cdf-48ec-a384-1968f741d7ef
# ╟─532adb3c-253a-48cd-a4d6-e09005e0fdd6
# ╟─ee79229b-e494-49f0-8803-7c194d5813da
# ╟─c044d604-f7e6-4e9e-8d9b-573d87f1c1cb
# ╟─a07b4f02-6fcb-4b39-89ff-10708d0feb1a
# ╟─64a239e5-07d7-47c4-ba3c-f169539d7955
# ╟─ae48fc8b-1ec7-4c1d-93c0-ff7ca89f9b93
# ╟─366f7326-4b2f-41e1-b320-60aa590d8809
# ╟─82742096-fb91-41df-9811-42e91230d6aa
# ╟─2dabdaad-bc63-456e-aa3e-7faf403638cc
# ╟─031d8553-bf0c-4d71-ae20-76d0e5354bdb
# ╟─de801713-bbf1-44f8-ab36-81191cb50b80
# ╟─e52fa7df-1c5f-4d1a-9058-99b5b3e0126c
# ╟─d23a6ee3-613e-4420-b2dc-ac34d72559c9
# ╟─4d7b0ade-4e23-48cb-819b-35e0613bdb41
# ╟─af2f9b54-7cc5-4f04-a311-ab22272c359a
# ╟─ede74c0d-ef84-49e3-8005-0cc689aad6b6
# ╟─15e4e7d7-be28-4d86-8606-8e68a72ded9f
# ╟─86764407-0e0e-44d9-8bee-b8fde107a7c5
# ╟─8dec3c53-d007-4d0c-bdc2-e2c9e59be024
# ╟─b4381585-3325-498d-9089-3e8f74201ce6
# ╟─816f1f5a-78f5-44fd-9986-5c9e51522ae1
# ╟─2f688dc7-8b92-4d2c-b830-184464f6d068
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
