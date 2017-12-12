# A brief introduction to the Kaede treebank (楓)

Kaede treebank is a Japanese constituent treebank,
which has clause level annotations with syntactic function labels,
e.g., syntactic role and clause type, and coordinated construction.
The treebank is designed to have complete binary trees, and
is currently composed of about 10,000 sentences from 
the Kyoto University Text Corpus (the Mainichi Shimbun Newspaper).


## Tags

### Part-of-speech tags (terminal symbols)

symbol | definition
------------ | -------------
NN  | Noun
NNP | Proper noun
NPR | Pronoun
NV | Verbal noun
VB  | Verb
ADJ | Adjective
ADNOM | Adnominal adjective
ADV | Adverb
AUX | Auxiliary verb
CONJ | Conjunction
NADJ | Nominal adjective
NADV | Nominal adverb
NNF  | Formal noun
NNFV | Formal noun (adverbial)
NUM  | Numeral
CL | Classifier
NV   | Verbal noun
PX | Prefix
SX | Suffix
SXNADJ | Suffix (nominal adjective)
PCS | Case particle
PADN | Adnominal particle
PBD  | Binding particle
PCO  | Parallel particle
PCJ  | Conjunctive particle
PEND | Sentence-ending particle
P  | Particle (others)
PNC | Punctuation
PAR | Parenthesis
SYM | Symbol
INTJ | Interjection
FIL | Filler

### Compound word tags (non-terminal symbols)

symbol | definition
------------ | -------------
AUXCOMP | Compound auxiliary verb
CLCOMP  | Compound classifier
NUMCOMP | Compound numeral
PCOMP   | Compound particle
PCOMPADN | Compound particle (adnominal)
PCOMPADV | Compound particle (adverbial)
SYMCOMP | Compound symbol


### Phrase tags (non-terminal symbols)

symbol | definition
------------ | -------------
NP | Noun phrase
VP | Verb phrase
VCP | Nominal predicate phrase (w/ copula)
VNP | Nominal predicate phrase (w/o copula)
VQP | Verb phrase (indirect question)
ADJP | Adjective phrase
NADJP | Nominal adjective phrase
ADVP | Adverbial phrase
PP | Postposition phrase
CONJP | Conjunction phrase
INTJP | Interjection phrase
FILP | Filler phrase
IP  | Inflectional phrase
IP-MAT  | Matrix phrase
IP-ADV  | Adverbial phrase
IP-REL  | Relative clause
IP-REL_sbj  | Relative clause (subject gap)
IP-REL_obj  | Relative clause (object gap)
IP-REL_ob2  | Relative clause (indirect object gap)
IP-ADN  | Adnominal clause (non-gap)
CP  | Complementizer phrase
CP-THT  | Quotation clause
CP-NNF | Nominalized clause
CP-QUE | Interrogative clause



### Function tags 

symbol | definition
------------ | -------------
-SBJ | Subjective case
-OBJ | Objective case
-OB2 | Indirect object case
-TMP | Temporal case
-LOC | Locative case
-COORD | Coordinated structure
-ZPRED-COORD | Coordinated structure with ellipsis of predicate
-APPOS | Apposition
-QUE  | Question
-ADV | Adverbial modification
-ADNOM | Adnominal modification
-MSR | Measure expression
-FRAG | Fragment


## Publications

- 田中貴秋, 永田昌明, 松崎拓也, 宮尾祐介, 植松すみれ: 統語情報と意味情報を統合した日本語句構造ツリーバンクの構築. 言語処理学会第20回年次大会予稿集, pp.737–740 (2014).
- Takaaki Tanaka and Masaaki Nagata.: Constructing a Practical Constituent Parser from a Japanese Treebank with Function Labels. In *Proceedings of 4th Workshop on Statistical Parsing of Morphologically-Rich Languages (SPMRL 2013)*, pp.108-118 (2013).
- Sumire Uematsu, Takuya Matsuzaki, Hiroaki Hanaoka, Yusuke Miyao, and Hideki Mima.: Integrating Multiple Dependency Corpora for Inducing Wide Coverage Japanese CCG Resources. In *Proceedings of the 51st Annual Meeting of the Association for Computational Linguistics (ACL 2013)*, pp. 1042-1051 (2013).
