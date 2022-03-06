.data 
	#eden integer e 4 byta pa za vkupno 20 integeri (4*20)
	vektor1: .space 80 #alocira vkupna memorija za prviot vektor so maks 20 integeri
	vektor2: .space 80 #alocira vkupna memorija za vtoriot vektor so maks 20 integeri
	proizvodi: .space 80 #alocira vkupna memorija za nizata od proizvodi so maks 20 integers
	index: .word 181258 #indeksot vo hex e 0002c40a
	
.text
li $v0,5  
syscall #vnesuvanje pocetnata adresa za nizata od sumi

add $s7,$v0,$zero #vo $s7 ja zacuvuva pocetnata adresa na zbirnata niza

li $v0,5 
syscall #vnesuva vrednost za goleminata na nizite

add $s0,$v0,$zero #zacuvuva golemina na vektorite vo $s0 registarot

addi $t0,$zero,0 #i=0
addi $t5,$zero,0 #brojacot na clenovi inicijaliziran na 0
loop1: #for(int i=0;i<$s0;i++),za vnesuvanje elementi vo prvata nizata
	slt $t1,$t5,$s0 #ako brojacot e pomal od $s0 togas $t1=1 odnosno ako brojacot e pogolem od $s0 $t1=0
	beq $t1,$zero,vtor_del #ako uslovot e ispolnet odi na vtor_del
	
	li $v0,5
	syscall #vnesuvanje integer od user input
	
	sw $v0, vektor1($t0) #zacuvuvanje na elementite vo nizata
	addi $t0,$t0,4 #pomestuvanje za 4 za sledniot broj da bide vnesen
	addi $t5,$t5,1 #brojacot zgolemuvanje za 1
	j loop1 #vrakjanje nazad za ponovo vnesuvanje
	
vtor_del: #vnesuvanje na vtorata niza po princip na prviot del (loop1)
	addi $t3,$zero,0 #i=0
	move $t5, $0 
	li $t5, 0	#resetiranje na brojacot na 0 vrednost
loop2: #for(int i=0;i<$s0;i++),za vnesuvnje elementi vo vtorata niza	 
	slt $t1,$t5,$s0 #ako brojacot e pomal od $s0 togas $t1=1 odnosno ako brojacot e pogolem od $s0 $t1=0
	beq $t1,$zero,krajjj #ako uslovot e ispolnet odi na krajjj
	
	li $v0,5
	syscall #vnesuvanje integer od user input
	
	sw $v0, vektor2($t3) #zacuvuvanje na elementite vo nizata
	addi $t3,$t3,4 #pomestuvanje za 4 za sledniot broj da bide vnesen
	addi $t5,$t5,1 #brojacot zgolemuvanje za 1
	j loop2 #vrakjanje nazad za ponovo vnesuvanje	
	
krajjj: #kraj na zadacata
	jal presmetka1 #povik na procedurata za izvrshuvanje na presmetkite
	#koga ke se zavrshi procedurata,ke prodolzi od tuka programata,adresata e zacuvana vo $ra
	
indeks: #presmetkata za zacuvuvanje na poslednite 16 bita od indeksot vo registar $s1
	move $s1,$0 
	li $s1,0 #cistenje na registar $s1

	la $t0, index #zacuvuvanje na adresata od index vo $t0
	lw $t2, 0($t0) #zacuvuvanje na vrednosta od $t0 vo $t2
	#sega ni treba maska so koja ke ja zamenime vrednosta na indeksot 0002c40a(hex)
	#taka sto ke ja smenime vrednosta od 0002c40a vo 0000c40a
 
	addi $t6,$zero,131072 #kreirame maskata so taa vrednost vo registar $t6
	xor $s1,$t6,$t2 #koristime xor za da go pretvorime bitot od 1 vo 0

	#pecatenje i kraj na programata		
	add $a0,$s2,0 #zacuvaj go skalarniot proizvod vo $a0
	li $v0,1
	syscall #ispecati go skalarniot proizvod na ekran
				
	li $v0, 10 #kraj na programata 
	syscall

#pocetok na procedurata
presmetka1: #priprema i cistenje registri za prvata presmetka
move $t0,$0
li $t0,0 #iscisti go $t0
addi $t6,$zero,0 
move $t1,$0 
li $t1,0 #iscisti go $t1
move $t5,$0
li $t5,0	#iscisti go $t5
loopProizvodi: #presmetkata za skalarniot proizvod
slt $t1,$t5,$s0 #ako brojacot e pomal od $s0 togas $t1=1 odnosno ako brojacot e pogolem od $s0 $t1=0
beq $t1,$zero,presmetka2 #ako uslovot e ispolnet odi na presmetkata za zbirot
lw $t4,vektor1($t0) #zemi go prviot clen od prvata niza i zacuvaj go vo $t4
lw $t7,vektor2($t0)	#zemi go prviot clen od vtorata niza i zacuvaj go vo $t7
mult $t4,$t7 #pomnozi gi elementite 
mflo $s1 #rezultatot zacuvaj go vo $s1
sw $s1,proizvodi($t6) #zacuvaj go rezultatot vo novata niza proizvodi
add $s2,$s2,$s1 #dodadi go proizvodot na vkupnata suma
addi $t0,$t0,4 #pomesti se na sledniot clen od prvata niza
addi $t6,$t6,4 #pomesti se na sledniot clen od vtorata niza
addi $t5,$t5,1 #zgolemi go brojacot za 1
j loopProizvodi #vrati se i izvrshi otponovo 

presmetka2: #priprema i cistenje registri za vtorata presmetka
move $t0,$0
li $t0,0 #resetiraj go $t0
addi $t6,$zero,0
move $t1,$0 
li $t1,0 #resetiraj go $t1
move $t5,$0
li $t5,0	#resetiraj go $t5
loopZbirovi: #presmetkata za zbirot
slt $t1,$t5,$s0 #ako brojacot e pomal od $s0 togas $t1=1 odnosno ako brojacot e pogolem od $s0 $t1=0
beq $t1,$zero,kraj #ako uslovot e ispolnet odi kaj kraj
lw $t4,vektor1($t0) #zemi go prviot clen od prvata niza i zacuvaj go vo $t4
lw $t7,vektor2($t0)	#zemi go prviot clen od vtorata niza i zacuvaj go vo $t7
add $s1,$t4,$t7 #soberi gi elementite i smesti gi vo $s1
sw $s1,0($s7) #sumata smesti ja kako element od novata niza 
addi $s7,$s7,4 #pomesti se na sledniot clen od nizata za vnesuvanje
addi $t0,$t0,4 #pomesti se na sledniot clen od dvete nizi vektor1 i vektor2
addi $t5,$t5,1 #zgolemi go brojacot za 1
j loopZbirovi #vrati se i izvrshi otponovo
kraj: #ja sodrzi komandata za kraj od procedurata
jr $ra #vrati se kaj povikot na procedurata
