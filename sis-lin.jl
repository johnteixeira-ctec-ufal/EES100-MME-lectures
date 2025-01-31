### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 8a6c1e60-cc31-11ef-1be9-7b2c18d3e3c5
using Plots, PlutoUI, HypertextLiteral, LinearAlgebra, Printf

# ╔═╡ cf294dd7-a0ca-466b-90d6-2aa1b6b0be43
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

# ╔═╡ cc619ca9-fcd0-483e-8bbc-31a24ac977bc
@htl"""
<style>
	main {
		margin: 0 auto;
		max-width: 2000px;
    	padding-left: max(160px, 10%);
    	padding-right: max(160px, 10%);
	}
	pluto-output code pre {
		font-size: 90%;
	}
	pluto-output details summary {
		font-weight: normal !important;
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
</style>
"""

# ╔═╡ 47970e08-997f-4254-bb2f-c97dfeba3390
TableOfContents()

# ╔═╡ f26da6de-3267-4159-a9ec-3378c330f615
begin
	Base.show(io::IO, f::Float64) = @printf(io, "%.4f", f)
	@htl"""
	<button onclick="present()">Apresentar</button>
	<div style="margin-top:3em;margin-bottom:7em;">
	</div>
	<title>EES100 - MÉTODOS MATEMÁTICOS PARA ENGENHARIA</title>
	<subtitle>Sistemas de equações algebricas lineares</subtitle>
	<author>Jonathan da Cunha Teixeira</author>
	<email><a href="mailto:jonathan.teixeira@ctec.ufal.br">jonathan.teixeira@ctec.ufal.br<a/></email>
	<semester>Programa de Pós-Graduação em Engenharia Civil<br>Engenharia de Petróleo<br>Universidade Federal de Alagoas</semester>
	<hr style=""/>
	"""
end

# ╔═╡ 7133755b-2dc8-4df5-8bee-3a77bad95e1f
md"""
# Sistemas de equações algebricas lineares

Muitas das equações fundamentais da engenharia são baseadas em leis de conservação. Algumas quantidades familiares decorrente de tais leis são massa, energia e momento. Em termos matemáticos, esses princípios levam a equações de equilíbrio ou continuidade que relacionam o comportamento do sistema conforme resposta da quantidade sendo modelada (massa, volume, força, deslocamento, etc) às propriedades ou características do sistema (taxas de reação, rigidez, resistividade, etc) e aos estímulos externos atuando no sistema (vazões, carregamentos/solicitações, diferença de potencial, etc).

A aplicação destas leis físicas na modelagem de sistemas em muitos casos origina a partir de um conjunto de equações algébricas lineares que devem ser resolvidas simultaneamente. Além disso, métodos de resolução de equações diferenciais com frequência levam à transformação das equações diferenciais em um conjunto de equações algébricas que podem ser então resolvidas. 

Por exemplo, os métodos de diferenças finitas, elementos finitos e dos volumes finitos consistem em dividir o domínio de solução em um conjunto de pequenos elementos/células discretos(as) ($\Omega_e$), onde são formuladas equações de balanço para cada elemento/célula e estas formam equações algébricas. Este processo, chamado de *discretização*, que origina um conjunto de equações algébricas lineares e resolvê-la para determinar os valores $x_1, x_2, \dots, x_n$ que satisfazem simultaneamente um conjunto de equações (em problemas mecânicos geralmente são os deslocamentos, já problemas envolvendo multiplas físicas pressões, concentrações, correntes elétricas, etc).

Outro exemplo, os problemas envolvendo equações não-lineares, onde todo procedimento numérico de resolução demanda, em cada iteração do procedimento, a resolução de sistemas lineares de mesma dimensão do sistema original. Assim, o desempenho do procedimento é absolutamente dependente da eficiência e acurácia do método de resolução de sistemas lineares de equações algébricas.

Portanto é fundamental conseguir definir quando um *sistema de equações algébricas lineares possui alguma solução* (ou seja, é **consistente**) e se essa solução é única ou envolve um certo número de parâmetros arbitrários. O estudo de sistemas de equações algébricas lineares é um dos tópicos fundamentais da álgebra linear.
"""

# ╔═╡ 5bc77469-45a0-4703-9d0a-e143ba8a53c2
md"""
De maneira simplificada um sistema de equações algebricas lineares é:

$$A\ x = b\quad A\in\mathbb{R}^{n\times n},\ x\in\mathbb{R}^n$$

ou

$$\sum_{i=1}^n\sum_{j=1}^n a_{ij} x_j = b_i$$

sendo $a_{ij}$ os coeficientes constantes, $b_i$ constantes, $x_j$ são os valores a determinar (incógnitas) e $n$ é o número de equações. A matriz aumentada do sistema é definida como $A_{aumentada}=[A|b]$

Na forma clássica:

$$a_{11}x_{1}+a_{12}x_{2}+\dots+a_{1n}x_{n} = b_1$$
$$a_{21}x_{1}+a_{22}x_{2}+\dots+a_{2n}x_{n} = b_2$$
$$\vdots\qquad\vdots\qquad\vdots\qquad\vdots\qquad\qquad$$
$$a_{n1}x_{1}+a_{n2}x_{2}+\dots+a_{nn}x_{n} = b_n$$

Na forma matricial,

$$\begin{bmatrix}
a_{11} & a_{12} & \dots & a_{1n}\\
a_{21} & a_{22} & \dots & a_{2n}\\
\vdots & \vdots & \vdots & \vdots\\
a_{n1} & a_{n2} & \dots & a_{nn}
\end{bmatrix} \begin{bmatrix}x_1\\ x_2\\ \vdots\\ x_n\end{bmatrix} = 
\begin{bmatrix}b_1\\ b_2\\ \vdots\\ b_n\end{bmatrix}$$

A interpretação gráfica da solução de sistema de equações algebricas lineares pode ser perceptivo apenas para $\mathbb{R}^{2\times 2}$. Desta forma, dado o sistema algébrico linear:

$$\begin{cases}3x_1 + 2x_2 = 8\\ -x_1 + 2x_2 = 2\end{cases}$$

cuja a solução é (4, 3) considerando $(x_1, x_2)$. Assim a representação gráfica da solução é:
"""

# ╔═╡ 688ff3a6-c085-4085-b349-ab7cd7410276
begin
	aij = range(-3,3,31)
	md"""
	a₁₁: $(@bind a₁₁ Slider(aij, show_value=true, default=3))
	a₁₂: $(@bind a₁₂ Slider(aij, show_value=true, default=2))
	
	a₂₁: $(@bind a₂₁ Slider(aij, show_value=true, default=-1))
	a₂₂: $(@bind a₂₂ Slider(aij, show_value=true, default=2))
	"""	
end

# ╔═╡ e1906b69-63d4-4858-9000-0b2083c31ccb
let
	r = range(0,6,50)
	x2_1 = (8.0 .- a₁₁ .* r)./a₁₂
	x2_2 = (2.0 .- a₂₁ .* r)./a₂₂
	plot(r, x2_1, c=:red, lw=2, label="$a₁₁ x₁+ $a₁₂ x₂ = 8")
	plot!(r, x2_2, c=:black, lw=2, label="$a₂₁ x₁+ $a₂₂ x₂ = 2")
	xlabel!("x₁")
	ylabel!("x₂")
end

# ╔═╡ 69d1af5c-f6b0-4eb8-93ec-16bb7a2b9f19
md"""
## Análise da Solução de Sistemas Algébricos Lineares - Existência, Unicidade e Condicionamento

A forma genérica de representação de um sistema algébrico linear qualquer é $Ax=b$, onde $A\in\mathbb{R}^{m\times n}$ é uma matriz retangular com $m$ linhas e $n$ colunas, $x\in\mathbb{R}^n$ e $b\in\mathbb{R}^m$. Para que o sistema linear possa ser *classificado* como **consistente** ou **existência de solução**, o posto (*rank*)[^1] de $A$ deve ser igual ao posto de $A_{aumentada}$. Portanto, podemos deparar com três situações:

1. O **número de equações menor que o número de incógnitas**, i.e. $m < n$. Neste caso, $m$ é o valor máximo do posto da matriz $A$, considerando $r$ o valor do posto, necessariamente devemos ter $r\le m$ e, para que o sistema seja *consistente*, o posto de $A_{aumentada}=[A\ b]$ também deve ser igual a $r$. Neste caso, **o sistema é consistente e apresenta um número infinito de soluções**. Portanto, temos $r$ incógnitas podem ser expressas por uma combinação linear de $n−r$ incógnitas.

2. O **número de equações igual o número de incógnitas** $m = n$: A matriz $A\in\mathbb{R}^{n\times n}$ é matriz quadrada, $x\in\mathbb{R}^n$ é o vetor de incógnitas e $b\in\mathbb{R}^n$ é chamado de vetor das constantes, com componentes conhecidos. Esta situação só *apresenta solução se a matriz $A$ for regular* (existir uma matriz inversa $A^{−1}$, tal que $A^{−1} A = A A^{−1} = I$) e se tiver o posto igual a $n$, a condição necessária e suficiente para que tal ocorra é $det(A)\ne 0$, desta forma não há possibilidade do posto da matriz $A_{aumentada}$, ser maior do que $n$, logo o sistema apresenta uma única solução ou **unicidade**.

3. O **número de equações é maior que o número de incógnitas**, aqui a matriz $A$ apresenta um número de colunas, $n$, menor do que o número de linhas, $m$, o valor máximo do posto(*rank*) de $A$ é $n$, como os vetores coluna de $A$ são de dimensão $m > n$ existe a possibilidade do posto de $A_{aumentada}$ ser igual a $n+1$, valor maior que o posto de $A$ tornando o **sistema inconsistente**. A consistência do sistema nesta situação é um indicativo de que as equações que estão em excesso, $m−n$ equações, não contradizem as $n$ equações consistentes utilizadas na resolução do sistema.

Resumindo, para o sistema de equações $A\cdot x = b$, temos

$$r = rank(A); r_a = rank(A_{aumentada})
\begin{cases}
	r=r_a,\text{ sistema consistente}
	\begin{cases}
		r=n,\text{ solução única}\\
		r<n,\ \infty \text{ soluções}
	\end{cases}\\
	r<r_a,\text{ sistema inconsistente}\rightarrow\text{ sem solução}
\end{cases}$$


**Mas como saber se a solução encontrada do sistema linear esta correta (acurado/preciso)?**

Se $\hat{x}$ for uma **solução computada** para o sistema linear $A\ x = b$, então seu **erro** é a diferença $\epsilon = x-\hat{x}$. É claro que este *erro não é conhecido*, pois se o fosse a solução exata (x) já seria conhecida!. Entretanto, uma maneira de avaliar a "**qualidade da solução**" obtida $\hat{x}$ é calculando o **resíduo** definido por $res = A x − A\hat{x}$ como $A x = b$, então $res = b−A\hat{x}$. Este **resíduo mede o grau de satisfação de $\hat{x}$ referente a restrição $A x = b$**. 

Se $res=0$, então $\hat{x}$ é a solução exata e o erro ($\epsilon$) e é nulo.

Para uma boa aproximação $\hat{x}\rightarrow x$ da solução exata, espera-se que **para cada elemento de $res$ seja próximo de zero** ($|res|\approx 0 \le\varepsilon$).

Além da análise de consistência de sistemas algébrico lineares é aconselhável também avaliar o **condicionamento da matriz** $A$ do sistema, pois para alguns sistemas, pequenas variações nos coeficientes causam uma grande variação na solução obtida impondo dificuldades numéricas na resolução do sistema e na inversão da matriz. Com base nisso, pode-se dividir os problemas em duas classes:

- **Problemas bem condicionados** (*well-conditioned*): são aqueles onde uma pequena variação em qualquer um dos elementos do problema causa somente uma pequena variação na solução do problema;

- **Problemas mal condicionados** (*ill-conditioned*): são problemas onde uma pequena variação em algum dos elementos causa uma grande variação na solução obtida. Estes problemas tendem a ser muito sensíveis em relação a erros de arredondamento.

Os quatro números de condicionamento mais usuais são:

(1) $\mathcal{N}(A) = \|A\|_e \|A^{−1}\|_e$ em que $\|A\|_e=\left(\sum_{i=1}^n \sum_{j=1}^n a_{ij}^2\right)^{1/2}$ é a norma euclidiana. 

(2) $\mathcal{M}(A) = \|A\|_{1}=\text{max}_{1\le i\le n}\sum_{j=1}^n |a_{ij}|$ é o valor da soma dos valores absolutos dos elemento das linhas $i$ da matriz $A$ que apresenta o maior valor.

(3) $\mathcal{P}(A) =\frac{\max |\lambda_i|}{\min |\lambda_i|}$, sendo $\lambda_i$ são valores característico de $A$ em módulo (ou da parte real dos mesmos).

(4) $\mathcal{K}(A)=\frac{\sigma_{max} (A)}{\sigma_{max} (A)}$, sendo $\sigma(A)$ são os valores singulares de $A$ ou a raiz quadrada dos valores característicos de $AA^T$.

Valores elevados dos números de condicionamento são indicativos de dificuldades numéricas na resolução do sistema e na inversão da matriz $A$.

---
[^1] número de vetores coluna linearmente independente
"""

# ╔═╡ f5b9a61a-f4e1-4031-ba2c-8a1de6c30116
details(
	md"""**Ex.1.** Considere o sistema linear dado por

	$$\begin{cases}0.0003 x_1 + 3 x_2 = 1.0002\\ x_1 + x_2 = 1\end{cases}$$

	Analise o condicionamento do sistemas através de $\mathcal{N}$.
	""",
	md"""A matriz do sistema é dado por:

	$$A = \begin{bmatrix}0.0003 & 3\\ 1 & 1\end{bmatrix}$$

	A inversa de $A$ é:

	$$A^{-1} = \begin{bmatrix}-\frac{1}{0.0003\times 9999} &\frac{10000}{9999}\\ \frac{1}{0.0003\times 9999}& -\frac{1}{9999}\end{bmatrix}$$
	
	Logo, $\|A\|_e=\left(0.0003^2 + 3^3 + 1^2 + 1^2\right)^{1/2} = 3.3166$ e  $\|A^{-1}\|_e=1.1057$
	
	O número de condicionamento $\mathcal{M}$ é:
	
	$$\mathcal{M}(A)=(3.3166)1.1057\approx 3.6672$$

	Este número de condição relativamente pequeno mostra que a matriz $A$ é bem condicionada (*well-condition*). Entretanto, este problema é sensível à precisão da aritmética (ou seja, efeitos de arredondamento), mesmo que seja bem condicionada. Este é um problema de precisão, não um problema de condição, para confirmar isso, resolver o sistema considerando 2, 4, 6 e 8 casas de precisão. 
	"""
)

# ╔═╡ 41455aec-3c97-48a4-80c0-a3b083d39a00
details(
	md"""**Ex.2.** Analisar o condicionamento do sistema algébrico linear[^2]
	
	$$\begin{cases}10 x_1 + 7 x_2 + 8 x_3 + 7 x_4 = 32\\ 7 x_1 + 5 x_2 + 6 x_3 + 5 x_4 = 23\\ 8 x_1 + 6 x_2 + 10 x_3 + 9 x_4 = 33\\ 7 x_1 + 5 x_2 + 9 x_3 + 10 x_4 = 31\end{cases}$$
	
	---
	[^2] Marcus, M. (1960). *Basic Theorems in Matrix Theory*. 1a edição. Volume 57. New York: Applied Mathematics Series, National Bureau of Standards 
	""",
	md"""A matriz $A$ é

	$$A=\begin{bmatrix}10 & 7 & 8 & 7\\ 7 & 5 & 6 & 5\\ 8 & 6 & 10 & 9\\ 7 & 5 & 9 & 10\end{bmatrix}$$
	
	
	Os quatro números de condicionamento do problema são:

	$$\mathcal{M}(A)=4488$$
	$$\mathcal{N}(A)=3009.579$$
	$$\mathcal{P}(A)=2984.093$$
	$$\mathcal{K}(A)=2984.093$$

	Tais valores elevados indicam que o problema é *mau condicionamento*. Os últimos dois números de condicionamento são iguais para matrizes simétrica.
	"""
)

# ╔═╡ 495dbfdb-a23a-4699-b522-2873abf21543
md"""
## Métodos de resolução

Existe uma grande variedade de métodos para resolução de sistemas lineares, sendo muitos deles dependentes da estrutura da matriz $A$ (matriz densa, esparsa, simétrica, tri-diagonal, bloco-diagonal, etc.). Os métodos são classificados em:

- Métodos diretos
- Métodos iterativos

Como as equações de sistemas de equações algébricas envolvem variáveis de diversas ordens de grandeza é importante, antes de aplicar qualquer procedimento de resolução, realizar *um reescalamento* das mesmas de modo a mantê-las com ordens de grandeza semelhantes. Um dos **métodos de reescalamento é o adimensionamento** que, além de reduzir a escala das variáveis, **torna o problema independente de sistema de unidades**.

### Métodos diretos

Métodos que após um número conhecido de passos encontra-se, caso exista, a solução do sistema. Os métodos diretos mais conhecidos (não por totalidade) para a resolução de sistemas lineares são:

- Eliminação de Gauss(-Jordan)
- Regra de Cramer
- Fatorações ($LU, LL^T, LDL^T, QR,\dots$)
- Método de Thomas

A princípio, os métodos de eliminação poderiam ser aplicados para qualquer sistema. No entanto, existem alguns problemas que limitam a utilização destes métodos para certas classes de problemas, especialmente envolvendo um grande número de equações.

#### Eliminação de Gauss(-Jordan)

A finalidade do Método de **Eliminação de Gauss** é reduzir a matriz $A$ a uma *estrutura triangular* (método de triangularização) ou diagonal (Método de **Eliminação de Gauss-Jordan**) através de operações da álgebra elementar. O método de diagonalização pode ser implementado pelo algoritmo.

A eliminação de Gauss essencialmente transforma o sistema de equações em:

$$\begin{bmatrix}a_{11} &a_{12} &\cdots &a_{1m}\\
				 0 &a_{22} &\cdots &a_{2m}\\
				 0 & \vdots & \ddots &\vdots\\
				0 & 0 &\cdots &a_{nm}
\end{bmatrix} \begin{bmatrix}x_1\\ x_2\\ \vdots\\ x_m\end{bmatrix} = 
\begin{bmatrix}b_1\\ b_2\\ \vdots\\ b_n\end{bmatrix}$$

---

**Diagonalização - algoritmo**

$\text{Entre com n (dimensão do sistema)\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad}$

$\text{Definindo }A = a_{ij}\text{ e }b=b_{ij}\text{ com }i,j=1,2,\dots ,n\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$\text{Construir a matriz }A_{aumentada}=[A|b]\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$\text{Para }i=1,2,\dots , n\text{, faça}\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$\alpha\leftarrow a_{ii}\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$\text{Para }j=1,2,\dots , n+1\text{, faça}\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$a_{ij}\leftarrow \frac{a_{ij}}{\alpha} \qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$\text{Para }k=1,2,\dots , n\wedge k\ne i\text{, faça}\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$\alpha\leftarrow a_{ki} \qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$\text{Para }j=1,2,\dots , n+1\text{, faça}\qquad\qquad\qquad\qquad\qquad\qquad\quad$

$a_{kj}\leftarrow a_{kj}-\alpha a_{ij} \qquad\qquad\qquad\qquad\qquad\qquad\qquad$

---
"""

# ╔═╡ 3c72ab8f-21f6-43c1-ba8b-a46bb2337aac
md"""
A eliminação de Gauss–Jordan resolve sistemas de equações reduzindo o sistema à $A_{aumentada} = [I|b]$. O método de triangularização pode ser implementado pelo algoritmo.

---

**Triangularização - algoritmo**

$\text{Entre com n (dimensão do sistema)\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad}$

$\text{Definindo }A = a_{ij}\text{ e }b=b_{ij}\text{ com }i,j=1,2,\dots ,n\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$\text{Construir a matriz }A_{aumentada}=[A|b]\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$\text{Para }i=1,2,\dots , n\text{, faça}\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$\alpha\leftarrow a_{ii}\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$\text{Para }j=1,2,\dots , n+1\text{, faça}\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$a_{ij}\leftarrow \frac{a_{ij}}{\alpha} \qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$\text{Para }k=i+1,\dots , n\wedge i< n\text{, faça}\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$\alpha\leftarrow a_{ki} \qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$\text{Para }j=1,2,\dots , n+1\text{, faça}\qquad\qquad\qquad\qquad\qquad\qquad\quad$

$a_{kj}\leftarrow a_{kj}-\alpha a_{ij} \qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$x_n\leftarrow a_{n n+1} \qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$\text{Para }i=n-1,n-2,\dots , 0\text{, faça}\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$x_i\leftarrow a_{in+1} \qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$\text{Para }j=i+1,\dots , n\text{, faça}\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$x_i\leftarrow x_i-a_{ij}x_j \qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$


---

"""

# ╔═╡ 8fd08df3-8e7a-4ccb-aa27-5e7a5e0cea05
md"""
#### Regra de Cramer

Embora não seja um método de eliminação, a regra de Cramer é um método direto para resolver sistemas de equações algébricas lineares. A regra de Cramer afirma que a solução para $x_j\ j = 1,\dots, n$ é dada por:

$$x_j = \frac{|A_j|}{|A|}$$

sendo $|A_j|$ é determinante da matriz $A_j$ que é uma matriz $n\times n$ obtida pela substituição da coluna $j$ da matriz $A$ pelo vetor coluna $b$, e $|A|$ é o determinante da matriz $A$ do sistema linear.

Portanto, A regra de Cramer é útil na solução manual de sistemas envolvendo determinantes que possam ser facilmente avaliados.
"""

# ╔═╡ 3aafafa4-15d9-41a8-a18c-74424f772368
md"""
#### Decomposição LU

A ideia deste método consiste em decompor a matriz dos coeficientes ($A$) como o produto de duas matrizes triangulares, uma inferior ($L$) e outra superior ($U$), assim:

$A = LU$

Com esta decomposição, convertemos o sistema de equações para a seguinte forma:

$$\begin{bmatrix}l_{11} & 0 & 0 & \dots & 0\\
				 l_{21} & l_{22} &  0 & \dots & 0\\
				 l_{31} & l_{32} &  l_{33} & \dots & 0\\
				 \vdots & \vdots &  \vdots & \ddots & 0\\
				 l_{n1} & l_{n2} &  0 & \dots & l_{nn}\\
\end{bmatrix}\begin{bmatrix}u_{11} & u_{12} & u_{13} & \dots & u_{1n}\\
				 0 & u_{22} &  u_{23} & \dots & u_{2n}\\
				 0 & 0 &  u_{33} & \dots & u_{3n}\\
				 \vdots & \vdots &  \vdots & \ddots & u_{mn}\\
				 0 & 0 &  0 & \dots & u_{nn}\\
\end{bmatrix}
\begin{bmatrix}x_1\\ x_2\\ \vdots\\ x_n\end{bmatrix} = 
\begin{bmatrix}b_1\\ b_2\\ \vdots\\ b_n\end{bmatrix}$$

O método segue dois passos para obter a solução:

1. **Passo da decomposição LU**. $A$ é decomposta em matrizes triangulares inferior $L$ e superior $U$.

2. **Passo de substituição**. $L$ e $U$ são usadas para determinar a solução $x$ para $b$. Esse passo consiste em duas etapas. Primeiro, resolvemos o sistema por substituição progressiva, dado por

$$L y = b$$

Em seguida, o resultado ($y$) é utilizado no sistema

$$U x = y$$

que pode ser resolvida por substituição regressiva, determinando-se $x$

Para encontrar a solução de $A$ podemos utilizar os método de Doolittle ($L$) e método de Crout ($U$).

Para o particular de a matriz $A$ ser **simétrica e positiva definida**, a fatoração LU pode ser feita pelo **método de Cholesky**.

Em caso da matriz $A$ **não for simétrica e positiva definida** o sistema original é modificado pela multiplicação de ambos os membros por $A^T$ resultando em $Mx = c$, onde $M = A^T A$ e $c = A^T b$, sendo $M$ uma matriz simétrica e positiva definida, possibilitando a aplicação do **método de Cholesky** ao sistema modificado. 

"""

# ╔═╡ e95711c0-786f-4359-ad10-b4dbaeffec1a
md"""
#### Método de Thomas

Um caso muito comum em um grande sistema de equações algébricas lineares, é o sistema tridiagonal ou diagonalmente dominante. Este tipo de sistema surge em problemas de Engenharia envolvendo, por exemplo, a modelagem de sistemas envolvendo discretização de equações diferenciais por métodos implícitos. Há vários métodos de eliminação direta para resolver sistemas de equações algébricas lineares que têm padrões especiais na matriz de coeficientes. Esses métodos são geralmente muito eficientes em tempo e armazenamento de computador. Esses métodos devem ser considerados quando a matriz de coeficientes se ajusta ao padrão necessário e quando o armazenamento e/ou tempo de execução do computador são importantes. 

Uma matriz é dita tridiagonal quando possui uma **largura de banda** igual a 3, ou seja, somente a diagonal principal e os elementos vizinhos acima e abaixo são não-nulos. Este tipo de matriz surge naturalmente na resolução de PVC's pelo método de diferenças finitas de EDP's através de métodos implícitos.

De forma geral, um sistema linear tridiagonal $n × n$ pode ser expresso como:

$$T x = b$$

sendo: 

$$T = \begin{bmatrix}
		a_{11} & a_{12} & 0 & 0 & 0 & \dots & 0 & 0 & 0\\
		a_{21} & a_{22} & a_{23} & 0 & 0 & \dots & 0 & 0 & 0\\
		0 & a_{32} & a_{33} & a_{34} & 0 & \dots & 0 & 0 & 0\\
		0 & 0 & a_{43} & a_{44} & a_{45} & \dots & 0 & 0 & 0\\
		\vdots & \vdots & \vdots & \vdots & \vdots & \dots & \vdots & \vdots & \vdots\\
		0 & 0 & 0 & 0 & 0 & \dots & a_{n-1,n-2} & a_{n-1,n-1} & a_{n-1,n}\\
		0 & 0 & 0 & 0 & 0 & \dots & 0 & a_{n,n-1} & a_{n,n}\\
\end{bmatrix}$$

Para resolver este tipo de sistema, pode-se utilizar uma versão simplicada do método de eliminação de Gauss conhecida como algoritmo de Thomas. De maneira generalizada, os elementos da diagonal principal após a eliminação passam a
ser avaliados como:

$$a^*_{ii} = a_{ii} - \frac{a_{i,i-1}}{a_{i-1,i-1}} a_{i-1,i}\qquad\qquad i=1,2,\dots n$$

$$b^*_{i} = b_{i} - \frac{a_{i,i-1}}{a_{i-1,i-1}} b_{i-1}\qquad\qquad\qquad\qquad\qquad$$

sendo $*$ utilizado para indicar o valor novo, obtido após o procedimento.

O método de resolução desta forma modificada de sistemas lineares tri-diagonais é descrita em [TDMA](https://www.cfd-online.com/Wiki/Tridiagonal_matrix_algorithm_-_TDMA_(Thomas_algorithm))
"""

# ╔═╡ 632df7c9-5da2-4754-8215-4cb382a8fb66
md"""
### Métodos iterativos

São métodos que **a partir de uma estimativa inicial da solução** e uma **equação de recorrência, procede iterações** sob uma sequência de vetores que tende à solução do sistema **até atingir certas condições/critérios**.

As técnicas iterativas são **raramente utilizadas** para a resolução de **sistemas algébricos lineares de baixas dimensões**, já que o tempo requerido para obter um mínimo de acurácia na aplicação dessas técnicas ultrapassa o tempo requerido pelas técnicas diretas. Contudo, *para sistemas de dimensões elevadas*, com grande porcentagem de elementos nulos (**sistemas esparsos/matrizes esparsas**), tais técnicas aparecem como alternativas mais eficientes. 

*Sistemas esparsos* de grande porte frequentemente surgem na *resolução numérica de equações diferenciais ordinárias com problemas de valor no contorno e de equações diferenciais parciais*. Da mesma forma que os métodos diretos, existe uma grande variedade de métodos iterativos para resolução iterativa de sistemas algébricos
lineares.

Reiterando que, os métodos iterativos *começam assumindo um vetor de solução inicial* ($x^o$). O vetor de solução inicial é usado para *gerar um vetor de solução melhorado* (x^n) com base em alguma estratégia para reduzir a diferença entre $x^o$ e o vetor de solução real $x^n$, $\varepsilon^n=|x^o - x^n|$.

Este procedimento é repetido (ou seja, iterado) para convergência. O procedimento é convergente se cada iteração produz aproximações para o vetor de solução que se aproximam do vetor de solução exato conforme o número de iterações aumenta. Métodos iterativos não convergem para todos os conjuntos de equações, nem para todos os arranjos possíveis de um conjunto particular de equações. A dominância diagonal é uma condição suficiente para a convergência da iteração de Jacobi, iteração de Gauss-Seidel e SOR, para qualquer vetor de solução inicial.

Todos os sistemas não singulares de equações algébricas lineares têm uma solução exata. **Métodos iterativos são menos suscetíveis a erros de arredondamento** do que métodos diretos por três razões:

(a) O sistema de equações é diagonalmente dominante,
(b) o sistema de equações é tipicamente esparso,
(c) cada iteração através das equações do sistema é independente dos erros de arredondamento da iteração anterior.

Quando resolvido por métodos iterativos, a solução exata de um sistema de equações algébricas lineares é alcançada sintoticamente conforme o número de iterações aumenta. Quando o número de iterações aumenta sem limites, a solução numérica produz a solução exata dentro do limite de arredondamento da maquina ($\epsilon$ da maquina). Tais soluções são ditas corretas para a precisão da máquina. Na maioria das soluções práticas, a precisão da máquina não é necessária!!.

Assim, o processo iterativo deve ser encerrado quando algum tipo de critério (ou critérios) de precisão for satisfeito. Em métodos iterativos, o termo **precisão** se refere ao número de algarismos significativos obtidos nos cálculos, e o termo **convergência** se refere ao ponto no processo iterativo quando a precisão desejada é obtida. Em geral os critério de convergência mais utilizados são:

(i) $res \le \varepsilon$

(ii) $\epsilon_{max} = \max_i|x_i^{k+1}-x_i^k| \le  \varepsilon$

(iii) $\frac{\max_i|x_i^{k+1}-x_i^k|}{x_i^k} \le  \varepsilon$

(iv) $k\le iter_{max}$



"""

# ╔═╡ b81afc9d-1e5c-43e2-8014-1de200480a1a
md"""
#### Método de Jacobi

É o método iterativo **mais simples** para a resolução de sistemas lineares. Apesar de apresentar uma **convergência relativamente lenta**, o método *funciona bem* para
sistemas esparsos com **grande dominância diagonal**, ou seja, onde os elmentos da diagonal principal são muito maiores que os demais elementos da mesma linha. 

No entanto, este **método não funciona** quando algum elemento da diagonal principal é nulo, logo uma condição necessária é que todos os elementos da diagonal principal sejam não nulos.

Considerando a decomposição da matriz característica do sistema: $A = D−(D−A)$ sendo $D$ a matriz diagonal que contém os elementos da diagonal principal da matriz A, temos:

$$A x =n\Rightarrow Dx + -(D-A)x = b$$
$$x = D^{-1}(D-A)x + D^{-1}b$$

Para $M=D^{-1}(D-A)$ e $c=D^{-1}b$, chegamos a expressão recurssica

$$x^{k+1}=Mx^k + c\qquad k=0,1,\dots$$

ou na forma indicial:

$$x_i^{k+1} = \frac{b_i - \sum_{j=1\ne i}^n a_{ij}x^k_i}{a_{ii}}\qquad i=1,2,\dots, n\quad k=0,1,\dots$$

sendo $b_i - \sum_{j=1\ne i}^n a_{ij}x^k_i$ é chamado de resíduo da equação ($res$).

"""

# ╔═╡ 1e5876e4-d23d-4f3d-9247-4c3282bd7181
md"""
#### Método de Gauss-Seidel

É um método iterativo específico que sempre usa o último valor estimado para cada elemento em x, isto é, primeiro supomos valores iniciais para $x_2, x_3,\dots, x_n$ (**exceto para $x_1$**) e calculamos $x_1$. Usando o $x_1$ calculamos e o resto dos $x$'s (**exceto para $x_2$**), para podermos calcular $x_2$. Continuando da mesma maneira e calculando todos os elementos em $x$ daí concluiremos a primeira iteração. A parte única do método Gauss–Seidel é o uso do valor mais recente para calcular o próximo valor em x.

Em outras palavras, considerando a decomposição da matriz característica do sistema para: $A = L+D+U$ sendo $D$ a **matriz diagonal** que contém os elementos da diagonal principal da matriz $A$, $L$ a **matriz triangular inferior** contendo os elementos sob a diagonal principal da matriz $A$ e $U$ a **matriz triangular superior** contendo os elementos sobre a diagonal principal da matriz $A$, assim:

$$A x = b\Rightarrow D x + (L+U) x = b$$
$$x = D^{−1} b−D^{−1} L x−D^{−1} U x$$

Desta forma a expressão recurssica é:

$$x^{k+1}=D^{−1} b−D^{−1} L x^{k+1}−D^{−1} U x^k$$

ou

$$x_i^{k+1} = \begin{cases}
				\frac{b_1 - \sum_{j=2}^n a_{1j}x_j^k}{a_{11}},\text{ para }i=1\\
				\frac{b_i - \sum_{j=1}^{i-1} a_{ij}x_j^k - \sum_{k=i+1}^n a_{ij}x_j^k}{a_{ii}},\text{ para }i=2,3,\dots, n\\
			  \end{cases}\qquad k=0,1,2, \dots$$

Fazendo analogia ao método de Jacobi a matrix $M$ no método de Gauss-Seidel é: $M=-(L+D)^{-1}U$

"""

# ╔═╡ 8e69a8f4-eb57-4c46-b974-69f14887dbbe
let
	r = range(-6,6,61)
	md"""
	x₂⁰: $(@bind x₂0 Slider(r, show_value=true, default=2))
	"""
end

# ╔═╡ 1f578319-8c20-47a5-a16a-226713ab8f2a
let
	s1(x) = (8.0 - a₁₂ * x)/a₁₁
	s2(x) = (2.0 - a₂₁ * x)/a₂₂
	iter = 12
	sol = zeros(iter+1,2); sol[1,:] = [s1(x₂0) x₂0]
	for i=2:2:iter
		sol[i,1] = s1(sol[i-1,2])
		sol[i,2] = sol[i-1,2]
		
		sol[i+1,1] = s1(sol[i-1,2])
		sol[i+1,2] = s2(sol[i,1])
	end
	
	r = range(-2,6,61)
	x2_1 = (8.0 .- a₁₁ .* r)./a₁₂
	x2_2 = (2.0 .- a₂₁ .* r)./a₂₂
	plot(r, x2_1, c=:red, lw=2, label="$a₁₁ x₁+ $a₁₂ x₂ = 8")
	plot!(r, x2_2, c=:black, lw=2, label="$a₂₁ x₁+ $a₂₂ x₂ = 2")
	plot!(sol[:,1], sol[:,2], c=:blue, lw=2, label="iterações G-S")
	scatter!(sol[:,1], sol[:,2], c=:blue, label=false)
	xlabel!("x₁")
	ylabel!("x₂")
end

# ╔═╡ 2455afff-96bb-44ca-a441-fce03413ac58
md"""
#### Método das {Sobre-}Relaxações Sucessivas (SOR)

Este procedimento visa **acelerar a convergência** do método de Gauss-Seidel pela introdução de um *fator de relaxação*, de acordo com o procedimento iterativo:

$$x_i^{k+1}=x_i^k+\omega\left(\hat{x}_i^{k+1}-x_i^k\right)$$

sendo $\hat{x}_i^{k+1}$ é a solução calculada pelo método de Gauss-Seidel. O parâmetro $\omega$ é o fator de relaxação, quando $1 <\omega$ o procedimento é dito de **sobre-relaxação (over-relaxation)** o que *acelera a convergência* do método de Gauss-Seidel (caso seja convergente). Escolhendo-se $0 < \omega < 1$ o método é chamado de **sub-relaxação** e pode *assegurar a convergência de procedimentos iterativos não-convergentes*.

Neste método a matriz $M$ do procedimento iterativo é:

$$M=I−\omega\left[L + D^{−1} U + I\right]$$

"""

# ╔═╡ 40eecf8e-9b2a-46a0-bf5d-6207ad55b9fa
md"""
---

**CONVERGÊNCIA DO MÉTODO**

A convergência destes 3 métodos iterativos é caracterizada pela matriz de iteração $M$ sendo: convergente se, e somente se, todos os **valores característicos de $M$** possuírem valor absoluto menor que 1. 

A convergência é também assegurada se a norma de $M$ ($\|M\|$) for menor que 1, podendo ser computada por alguma das definições a seguir:

---
"""

# ╔═╡ dd64f6a0-43f6-4fc2-ab14-a1b535dd4c88
md"""

#### Métodos iterativos baseados em minimização da forma quadrática

Nestes tipos de métodos exige-se que a matriz dos coeficientes $A$ seja **quadrada, simétrica e positiva definida** (todos os autovalores positivos).

O procedimento inicial é: dado o problema original, $A x = b$, este é transformado de forma a **assegurar** que a matriz característica do sistema ($A$) **seja positiva definida e simétrica**, para isto deve-se multiplicar ambos os lados da equação pela matriz $A^T$:

$A x = b\Rightarrow A^T A x = A^T b$ definindo $M = A^T A$ e $c = A^T b$ resulta em:

$$M x = c$$

Desta forma, o problema é então transformado em um **problema de minimização da função quadrática**:

$$\mathcal{S}(x)=\frac{1}{2}x^T M x - c^T x\Rightarrow \nabla\mathcal{S}(x) = M x - c$$

O processo iterativo **é orientado na busca do valor de x que anula** $res=M x - c$, iniciando o procedimento iterativo partindo de $x^0$ calcula-se a seguir $res(x^0) = M x^0 −c$. O próximo valor de $x^{1}$ é buscado na direção $p^0$ com um passo $\pi_o$, isto é:

$$x^1 = x^0 + \pi_op^0\rightarrow res(x^1) = res(x^0) + \pi_oMp^0$$ 

Para minizar $res(x^1)$ este deve ser ortogonal a $p^0$, logo:

$$\pi_o=-\frac{res(x^0)^T p^0}{res(x^0)^TM p^0}$$

Então o valor, inicial ($p^k$), da direção de busca, $p^k$, é escolhido pelo:

1. Método da "descida mais íngreme" (*steepest descent*)

$$p^0 = -\nabla\mathcal{S}(x^0) = -res(x^0)\qquad p^k = -\nabla\mathcal{S}(x^k) = -res(x^k)$$

2. Método conjugado

$$p^k = -res(x^k) + \frac{res(x^k)^T M p^{k-1}}{(p^{k-1})^T M p^0} p^{k-1}$$

Resumidamente:

---
$$x^0\leftarrow\text{valor inicial}\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$$

$res^0\leftarrow M x^0 - c\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$p^0\leftarrow res^0\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$\pi^0\leftarrow -\frac{(res^0)^T p^0}{(p^0)^T M p^0} \qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$x^1\leftarrow x^0+\pi^0 p^0 \qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$res^1\leftarrow res^0+\pi^0 M p^0 \qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$\text{Para }k=1,2,\dots\text{ faça:} \qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$\color{blue}\text{\# para gradientes conjugados...} \qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$incr = \frac{(res^k)^T M p^{k-1}}{(p^{k-1})^T M p^{k-1}} \qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$p^k = - res^k + incr\ p^{k-1} \qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$\color{blue}\text{\# para steepest descent ...} \qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$p^k = - res^k \qquad\qquad\quad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$\pi^k\leftarrow -\frac{(res^k)^T p^k}{(p^k)^T M p^k} \qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$x^{k+1}\leftarrow x^{k}+\pi^{k} p^{k} \qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$

$res^{k+1}\leftarrow res^k+\pi^k M p^k \qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$


---
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Printf = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[compat]
HypertextLiteral = "~0.9.5"
Plots = "~1.40.9"
PlutoUI = "~0.7.60"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.8"
manifest_format = "2.0"
project_hash = "263f9c23cc17a6a1be8a3f3bd1aec61958d66927"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.AliasTables]]
deps = ["PtrArrays", "Random"]
git-tree-sha1 = "9876e1e164b144ca45e9e3198d0b689cadfed9ff"
uuid = "66dad0bd-aa9a-41b7-9441-69ab47430ed8"
version = "1.1.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "0691e34b3bb8be9307330f88d1a3c3f25466c24d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.9"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "8873e196c2eb87962a2048b3b8e08946535864a1"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+4"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "009060c9a6168704143100f36ab08f06c2af4642"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.18.2+1"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "bce6804e5e6044c6daab27bb533d1295e4a2e759"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.6"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "c785dfb1b3bfddd1da557e861b919819b82bbe5b"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.27.1"

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

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "64e15186f0aa277e174aa81798f7eb8598e0157e"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.13.0"

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

[[deps.ConcurrentUtilities]]
deps = ["Serialization", "Sockets"]
git-tree-sha1 = "f36e5e8fdffcb5646ea5da81495a5a7566005127"
uuid = "f0e56b4a-5159-44fe-b623-3e5288b988bb"
version = "2.4.3"

[[deps.Contour]]
git-tree-sha1 = "439e35b0b36e2e5881738abc8857bd92ad6ff9a8"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.3"

[[deps.DataAPI]]
git-tree-sha1 = "abe83f3a2f1b857aac70ef8b269080af17764bbe"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.16.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "1d0a14036acb104d9e89698bd408f63ab58cdc82"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.20"

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

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

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
git-tree-sha1 = "f42a5b1e20e009a43c3646635ed81a9fcaccb287"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.6.4+2"

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

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

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

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll", "libdecor_jll", "xkbcommon_jll"]
git-tree-sha1 = "fcb0584ff34e25155876418979d4c8971243bb89"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.4.0+2"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Preferences", "Printf", "Qt6Wayland_jll", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "p7zip_jll"]
git-tree-sha1 = "424c8f76017e39fdfcdbb5935a8e6742244959e8"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.73.10"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "FreeType2_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Qt6Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "b90934c8cb33920a8dc66736471dc3961b42ec9f"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.73.10+0"

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

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IrrationalConstants]]
git-tree-sha1 = "630b497eafcc20001bba38a4651b327dcfc491d2"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.2.2"

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
git-tree-sha1 = "3447a92280ecaad1bd93d3fce3d408b6cfff8913"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "3.1.0+1"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "170b660facf5df5de098d866564877e119141cbd"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.2+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "78e0f4b5270c4ae09c7c5f78e77b904199038945"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "4.0.0+2"

[[deps.LLVMOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "78211fb6cbc872f77cad3fc0b6cf647d923f4929"
uuid = "1d63c593-3942-5779-bab2-d838dc0a180e"
version = "18.1.7+0"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "854a9c268c43b77b0a27f22d7fab8d33cdb3a731"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.2+3"

[[deps.LaTeXStrings]]
git-tree-sha1 = "dda21b8cbd6a6c40d9d02a73230f9d70fed6918c"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.4.0"

[[deps.Latexify]]
deps = ["Format", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Requires"]
git-tree-sha1 = "ce5f5621cac23a86011836badfedf664a612cee4"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.16.5"

    [deps.Latexify.extensions]
    DataFramesExt = "DataFrames"
    SparseArraysExt = "SparseArrays"
    SymEngineExt = "SymEngine"

    [deps.Latexify.weakdeps]
    DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
    SymEngine = "123dc426-2d89-5057-bbad-38513e3affd8"

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
git-tree-sha1 = "a7f43994b47130e4f491c3b2dbe78fe9e2aed2b3"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.51.0+2"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "61dfdba58e585066d8bce214c5a51eaa0539f269"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.17.0+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "d841749621f4dcf0ddc26a27d1f6484dfc37659a"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.40.2+1"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "XZ_jll", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "b404131d06f7886402758c9ce2214b636eb4d54a"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.7.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "9d630b7fb0be32eeb5e8da515f5e8a26deb457fe"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.40.2+1"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

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

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "2fa9ee3e63fd3a4f7a9a4f4744a52f4856de82df"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.13"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

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

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "0877504529a3e5c3343c6f8b4c0381e57e4387e4"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

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
version = "0.8.1+2"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "38cb508d080d21dc1128f7fb04f20387ed4c0af4"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.4.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "7493f61f55a6cce7325f197443aa80d32554ba10"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.0.15+3"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "6703a85cb3781bd5909d48730a67205f3f31a575"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.3+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "12f1439c4f986bb868acda6ea33ebc78e19b95ad"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.7.0"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.42.0+1"

[[deps.Pango_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "FriBidi_jll", "Glib_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ed6834e95bd326c52d5675b4181386dfbe885afb"
uuid = "36c8627f-9965-5494-a995-c6b170f724f3"
version = "1.55.5+0"

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
git-tree-sha1 = "eba4810d5e6a01f612b948c9fa94f905b49087b0"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.60"

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
git-tree-sha1 = "77a42d78b6a92df47ab37e177b2deac405e1c88f"
uuid = "43287f4e-b6f4-7ad1-bb20-aadabca52c3d"
version = "1.2.1"

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
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "3bac05bc7e74a75fd9cba4295cde4045d9fe2386"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.2.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "f305871d2f381d21527c770d4788c06c097c9bc1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.2.0"

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

[[deps.StableRNGs]]
deps = ["Random"]
git-tree-sha1 = "83e6cce8324d49dfaf9ef059227f91ed4441a8e5"
uuid = "860ef19b-820b-49d6-a774-d7a799459cd3"
version = "1.0.2"

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

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

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

[[deps.TranscodingStreams]]
git-tree-sha1 = "0c45878dcfdcfa8480052b6ab162cdd138781742"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.11.3"

[[deps.Tricks]]
git-tree-sha1 = "7822b97e99a1672bfb1b49b668a6d46d58d8cbcb"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.9"

[[deps.URIs]]
git-tree-sha1 = "67db6cc7b3821e19ebe75791a9dd19c9b1188f2b"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "01915bfcd62be15329c9a07235447a89d588327c"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.21.1"

    [deps.Unitful.extensions]
    ConstructionBaseUnitfulExt = "ConstructionBase"
    InverseFunctionsUnitfulExt = "InverseFunctions"

    [deps.Unitful.weakdeps]
    ConstructionBase = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
    InverseFunctions = "3587e190-3f89-42d0-90ee-14403ec27112"

[[deps.UnitfulLatexify]]
deps = ["LaTeXStrings", "Latexify", "Unitful"]
git-tree-sha1 = "975c354fcd5f7e1ddcc1f1a23e6e091d99e99bc8"
uuid = "45397f5d-5981-4c77-b2b3-fc36d6e9b728"
version = "1.6.4"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
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
git-tree-sha1 = "a2fccc6559132927d4c5dc183e3e01048c6dcbd6"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.13.5+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "7d1671acbe47ac88e981868a078bd6b4e27c5191"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.42+0"

[[deps.XZ_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ecda72ccaf6a67c190c9adf27034ee569bccbc3a"
uuid = "ffd25f8a-64ca-5728-b0f7-c24cf3aae800"
version = "5.6.3+1"

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
git-tree-sha1 = "2b0e27d52ec9d8d483e2ca0b72b3cb1a8df5c27a"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.11+3"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "807c226eaf3651e7b2c468f687ac788291f9a89b"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.3+0"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "02054ee01980c90297412e4c809c8694d7323af3"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.4+3"

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
git-tree-sha1 = "fee57a273563e273f0f53275101cd41a8153517a"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.1+3"

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
git-tree-sha1 = "b9ead2d2bdb27330545eb14234a2e300da61232e"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.5.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "555d1076590a6cc2fdee2ef1469451f872d8b41b"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.6+3"

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
git-tree-sha1 = "1827acba325fdcdf1d2647fc8d5301dd9ba43a9d"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.9.0+0"

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
git-tree-sha1 = "b70c870239dc3d7bc094eb2d6be9b73d27bef280"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.44+2"

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
# ╟─8a6c1e60-cc31-11ef-1be9-7b2c18d3e3c5
# ╟─cf294dd7-a0ca-466b-90d6-2aa1b6b0be43
# ╟─cc619ca9-fcd0-483e-8bbc-31a24ac977bc
# ╟─47970e08-997f-4254-bb2f-c97dfeba3390
# ╟─f26da6de-3267-4159-a9ec-3378c330f615
# ╟─7133755b-2dc8-4df5-8bee-3a77bad95e1f
# ╟─5bc77469-45a0-4703-9d0a-e143ba8a53c2
# ╟─688ff3a6-c085-4085-b349-ab7cd7410276
# ╟─e1906b69-63d4-4858-9000-0b2083c31ccb
# ╟─69d1af5c-f6b0-4eb8-93ec-16bb7a2b9f19
# ╟─f5b9a61a-f4e1-4031-ba2c-8a1de6c30116
# ╟─41455aec-3c97-48a4-80c0-a3b083d39a00
# ╟─495dbfdb-a23a-4699-b522-2873abf21543
# ╟─3c72ab8f-21f6-43c1-ba8b-a46bb2337aac
# ╟─8fd08df3-8e7a-4ccb-aa27-5e7a5e0cea05
# ╟─3aafafa4-15d9-41a8-a18c-74424f772368
# ╟─e95711c0-786f-4359-ad10-b4dbaeffec1a
# ╟─632df7c9-5da2-4754-8215-4cb382a8fb66
# ╟─b81afc9d-1e5c-43e2-8014-1de200480a1a
# ╟─1e5876e4-d23d-4f3d-9247-4c3282bd7181
# ╟─8e69a8f4-eb57-4c46-b974-69f14887dbbe
# ╟─1f578319-8c20-47a5-a16a-226713ab8f2a
# ╟─2455afff-96bb-44ca-a441-fce03413ac58
# ╟─40eecf8e-9b2a-46a0-bf5d-6207ad55b9fa
# ╟─dd64f6a0-43f6-4fc2-ab14-a1b535dd4c88
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
