<CsoundSynthesizer>
<CsOptions>
-o dac
-+rtmidi=null
-+rtaudio=null
-d
-+msg_color=0
-M0
-m0
</CsOptions>
<CsInstruments>
nchnls=2
0dbfs=1
ksmps=10
kr = 4410
sr = 44100

massign 0, 1
seed 0
maxalloc 1, 7

garvbR      init 0
garvbL      init 0
gachorus1   init 0
gachorus2   init 0
gamousy     init 0
gamousy2    init 0
gadelay     init 0
gadisto     init 0
gaMelo      init 0
gkcount     init 1


/*lfo variables for machine instrument */
gkLfoAmp     init 1
gkLfoPitch   init 1
gkLfoCutoff  init 1
gkLfoPan     init 1

#define PORTAMENTO(var'portt)#
kportt linseg 0, $portt, 0, 0, $portt
$var portk $var, kportt, -1
#

	/* GLOBAL FTABLE USED MAINLY BY THE ZUCCO PAD */
gisaw		     ftgen	0,0,4096,11,80,1,0.9
gicos		     ftgen	0,0,4096,11,1		
gieqffn	     ftgen	0,0,4097,7,-1,4096,1
gieqlfn	     ftgen	0,0,4097,7,-1,4096,1
gieqqfn	     ftgen	0,0,4097,7,-1,4096,1
gifn	           ftgen	0,0, 257, 9, .5,1,270,1.5,.33,90,2.5,.2,270,3.5,.143,90,4.5,.111,270
gicut           ftgen   7, 0, 129,  -25, 0, 10.0,  128, 9500.0


#define TREMOLO_RATE_DOTTEDQUARTER(TEMPON) #90.0/$TEMPO#
#define TREMOLO_RATE_QUARTER(TEMPO) #60.0/$TEMPO#
#define TREMOLO_RATE_EIGHT(TEMPO) #30.0/$TEMPO#
#define TREMOLO_RATE_SIXTEEN(TEMPO) #15.0/$TEMPO#

turnon 1
turnon 22
turnon 99
turnon 100
turnon 101
turnon 102


;udo converting MIDI notes to frequency herz
opcode	cpsmid, k, k

kmid	xin

#define MIDI2CPS(xmidi) # (440.0*exp(log(2.0)*(($xmidi)-69.0)/12.0)) #
kcps	=	$MIDI2CPS(kmid)

xout	kcps

endop
opcode	cpsmidforI, i, i

imid	xin

#define MIDI2CPS(xmidi) # (440.0*exp(log(2.0)*(($xmidi)-69.0)/12.0)) #
icps	=	$MIDI2CPS(imid)

xout	icps

endop


		/* INSTRUMENT RECEIVING MIDI */
/* UDO 1: GLASS ATONAL */				
opcode CHOWNglass,a,kai

kamp,anote,ifunc xin

kgate         linenr    kamp, 0, .2, .01
imfreq        =         1.4 * 200
immax         =         10 * imfreq
kmenv         linseg    1, 5/6, 0, 5 - (5/6), 0
koenv         expseg    0.8, 5/6, 1, 5 - (5/6) , .01
amod          poscil    kmenv * immax, 1.414*anote, ifunc
aout          poscil    koenv * 1, anote + amod, ifunc
 
aFinal clip aout, 0, 0dbfs
 
xout aFinal*kgate         

       endop
       
/* UDO 2: PIANO */
opcode CHOWNPiano,a,kai

kamp,acps,ifunc xin

;gitemp100  ftgen 0,0 ,128 ,7, 0, 128 , 1

kndx	expon	1,	.3,	.01

a1	foscili	kamp,	k(acps),	1,	12,	kndx,	ifunc
a2	foscili	kamp,	k(acps) + .1,	1,	12,	kndx,	ifunc
a3	foscili	kamp,	k(acps) - .1,	1,	12,	kndx,	ifunc

aosc	=	a1 + a2 + a3
kenv	mxadsr	.01,	.1,	.65,	.1
aosc	=	aosc * .5

aout =	aosc*kenv
  
  aFinal clip aout, 0, 0dbfs
       
xout aFinal         

       endop

/* UDO 3: STRING */
opcode LucyTune,a,kk

kamp,knote xin
;setksmps 10

aout1     foscil    kamp, knote,     1, 2, kamp*2, 1
aout2     foscil    kamp, knote*2, 1, 1, kamp*2, 1

xout  (aout1+aout2*.5)      
       endop

/* UDO 4: XYLOPHONE */
opcode CATFiltBank, a, ka
kamp,anote xin

ibw       =         2
;a1       oscil     30000, 1/1.3113, 1
a1        rand      100
kmov      =   1
af1       butterbp  a1, anote+kmov, ibw
af2       butterbp  a1, anote*2+kmov, ibw
af3       butterbp  a1, anote*2+kmov, ibw
af4       butterbp  a1, anote*4+kmov, ibw
af5       butterbp  a1, anote*8+kmov, ibw

aFinal clip  ((af1+af2+af3+af4+af5)*kamp)/5.0, 0, 0dbfs
          xout     aFinal 
          
	 endop

		instr 1
		
/*ADSR SEGMENTS */
iAttackAmp chnget "AttackAmp"
iAttackTime chnget "AttackTime"
iDecayAmp chnget "DecayAmp"
iDecayTime chnget "DecayTime"
iSustainAmp chnget "SustainAmp"
iReleaseTime chnget "ReleaseTime"

/* FX SENDS */
krvbAmount chnget "rvbAmountPlayer"
kchorusAmount chnget "chorusAmountPlayer"
kdelayAmount chnget "delayAmountPlayer"
kdistoAmount chnget "distoAmountPlayer"
kmasterVolume chnget "volumeAmountPlayer"

/* INSTRUMENT FLAG */
kInstrFlag chnget "instrPlayerFlag"

/* LFO FLAG */
kLfoFlag chnget "lfoDestination"
kLfoWaveType chnget "lfoWaveType"
kLfoRate chnget "lfoRate"
klfoAmount chnget "lfoAmount"
klfoComp = (1.0-klfoAmount)

midinoteonkey p4, p5


kpch cpsmid (p4+12)
kvel = p5
kScaledVel = (p5/127)
kamp = 0.5
kpitch = p4


/* Set LFO to right destination */
aLfo1 lfo klfoAmount, kLfoRate, i(kLfoWaveType)
aLfo2  lfo 8000*klfoAmount, kLfoRate, i(kLfoWaveType)

aLfo123 lowpass2 aLfo1, 40, 1
aLfo4 lowpass2 aLfo2, 40, 1
aPitchLfo init
/* To smooth out cutoff change */
kportt linseg 0, .01, 0, 0, .1
    
;    kLfo      tablei      kLfo, gicut, 1
;    kLfo portk kLfo, kportt, -1

;set the channels to communicate MIDI values to csound
chnset kpitch, "pitch"
chnset kvel, "velocity"
;simple sine-based instrument
if(kpitch < 100)then

	a2 linsegr 0,iAttackTime,iAttackAmp,iDecayTime,iDecayAmp,iReleaseTime,0
	
	if(kLfoFlag == 1)then
	aPitchLfo = aLfo123
	else
	aPitchLfo = 1
	endif
	if(kInstrFlag == 1)then
		a1 CHOWNglass kScaledVel, kpch*(aPitchLfo+klfoComp), 1
	elseif(kInstrFlag == 2)then
		a1 CHOWNPiano kScaledVel, kpch*(aPitchLfo+klfoComp), 1	
	elseif(kInstrFlag == 3)then
		a1 LucyTune kScaledVel, kpch*(k(aPitchLfo)+klfoComp)	
	elseif(kInstrFlag == 4)then
		a1 CATFiltBank kScaledVel, kpch*(aPitchLfo+klfoComp)
	endif
	
	if(kLfoFlag == 2)then
		a3 lowpass2 a1*a2, (k(aLfo4)+20)+(8000+klfoComp), 1
	else
		a3 lowpass2 a1*a2, 9500, 1
		endif		
aoutFinal clip a3,0,0dbfs
aoutFinal*= kmasterVolume
if(kLfoFlag == 0)then
aoutFinal *= (aLfo123+klfoComp)
endif

	if(kLfoFlag == 3)then
	outs (aoutFinal/gkcount)*(aLfo123+klfoComp), (aoutFinal/gkcount)*((1-aLfo123)+klfoComp)
	else 
	outs (aoutFinal/gkcount), (aoutFinal/gkcount)
	endif
endif

vincr garvbL, aoutFinal*krvbAmount
vincr garvbR, aoutFinal*krvbAmount
vincr gachorus1, aoutFinal*kchorusAmount
vincr gachorus2, aoutFinal*kchorusAmount
vincr gadisto, aoutFinal*kdistoAmount
vincr gadelay, aoutFinal*kdelayAmount
		endin


			/*  MACHINE INSTRUMENT  */
			
			


		/* 1. PLUCK RESONATOR BY ADAM BOULANGER */
		
		
			instr 	21
/* FILTER VALUES */
kfilterCutoff chnget "filterCutoff"
kfilterResonance chnget "filterResonance"

/* FX SENDS */
krvbAmount    chnget "rvbAmountMachine"
kchorusAmount chnget "chorusAmountMachine"
kdelayAmount  chnget "delayAmountMachine"
kdistoAmount  chnget "distoAmountMachine"
kmasterVolume  chnget "volumeAmountMachine"
/* To smooth out filter values change */
kportt linseg 0, .1, 0, 0, .1
    
;    kfilterCutoff      tablei      kfilterCutoff, gicut, 1
;    kfilterCutoff portk kfilterCutoff, kportt, -1
;    
;    kfilterResonance      tablei      kfilterResonance, gicut, 1
;    kfilterResonance portk kfilterResonance, kportt, -1

kpch cpsmid (p4+12)
kvel = p5	
ipch cpsmidforI (p4+12)
iAttackTime = p6
iReleaseTime = p7
		
ablock2 	init   	0
ablock3 	init   	0

kres		= 110					;Added:Tune reson filters
kres2		=220
kblk3mod	=.80					;Added:Offset DC block
kmod		= 0					;Added:Microtune pch
kmod		lfo		2, .02
ablk		pluck 	1, kpch, ipch, 0, 1
ablock2 	=      	ablk-ablock3+kblk3mod*ablock2	;THIS IS A DC BLOCKING FILTER
ablock3 	=      	ablk                        	;USED TO PREVENT DRIFT AWAY FROM
asig    	=      	ablock2                     	;ZERO.
af1			reson	asig, kres, 80
af2			reson	asig, kres2, 80
af3			reson	asig, 440, 80
abalnc		balance 1*af1+af2+0.6*af3+0.6*asig, asig
kenv		linseg	0, iAttackTime, 1.3, iReleaseTime, 0
afinal = kenv*abalnc

asig2 = afinal*(kvel/127)

aScaled clip	asig2,0,0dbfs
aScaled *= kmasterVolume

aScaled lowpass2 aScaled, kfilterCutoff, kfilterResonance
 
			outs aScaled, aScaled
			
vincr garvbL, aScaled*krvbAmount
vincr garvbR, aScaled*krvbAmount
vincr gachorus1, aScaled*kchorusAmount
vincr gachorus2, aScaled*kchorusAmount
vincr gadisto, aScaled*kdistoAmount
vincr gadelay, aScaled*kdelayAmount
			endin
			
	
		/* 2. MARIMBA INSTRUMENT */
		
		
			instr      22
/* FILTER VALUES */
kfilterCutoff chnget "filterCutoff"
kfilterResonance chnget "filterResonance"

/* FX SENDS */
krvbAmount    chnget "rvbAmountMachine"
kchorusAmount chnget "chorusAmountMachine"
kdelayAmount  chnget "delayAmountMachine"
kdistoAmount  chnget "distoAmountMachine"
kmasterVolume  chnget "volumeAmountMachine"

/* To smooth out cutoff change */
kportt linseg 0, .1, 0, 0, .1
    
    kfilterCutoff      tablei      kfilterCutoff, gicut, 1
    kfilterCutoff portk kfilterCutoff, kportt, -1

kpch cpsmid (p4)
kvel = p5	
ipch cpsmidforI (p4)

  ihrd = p6
  ipos = 0.561
  imp = 3
  kvibf = 2.0
  kvamp = 0.05
  ivibfn = 1
  idec = p7

  a1 marimba 1.0, kpch, ihrd, ipos, imp, kvibf, kvamp, ivibfn, idec, 0.1, 0.1
  aoutFnl clip	a1,0,0dbfs
  
asig2 = aoutFnl*(kvel/127)

aScaled clip	asig2,0,0dbfs
aScaled *= kmasterVolume  
  
	outs aScaled,aScaled
vincr garvbL, aScaled*krvbAmount
vincr garvbR, aScaled*krvbAmount
vincr gachorus1, aScaled*kchorusAmount
vincr gachorus2, aScaled*kchorusAmount
vincr gadisto, aScaled*kdistoAmount
vincr gadelay, aScaled*kdelayAmount

			endin	
	

		/* 3. FLUTE INSTRUMENT */
		
		
			instr      23
/* FILTER VALUES */
kfilterCutoff chnget "filterCutoff"
kfilterResonance chnget "filterResonance"

/* FX SENDS */
krvbAmount    chnget "rvbAmountMachine"
kchorusAmount chnget "chorusAmountMachine"
kdelayAmount  chnget "delayAmountMachine"
kdistoAmount  chnget "distoAmountMachine"
kmasterVolume  chnget "volumeAmountMachine"

/* To smooth out cutoff change */
kportt linseg 0, .1, 0, 0, .1
    
    kfilterCutoff      tablei      kfilterCutoff, gicut, 1
    kfilterCutoff portk kfilterCutoff, kportt, -1

kpch cpsmid (p4)
kvel = p5
ipch cpsmidforI (p4)
iAttackTime = p6
iReleaseTime = p7
 
a2 linseg 0, iAttackTime, 0.55, iReleaseTime, 0
a1 oscili a2*(kvel/127), kpch*2, 1
aScaled clip	a1,0,0dbfs
aScaled *= kmasterVolume
  
	outs aScaled,aScaled

vincr garvbL, aScaled*krvbAmount
vincr garvbR, aScaled*krvbAmount
vincr gachorus1, aScaled*kchorusAmount
vincr gachorus2, aScaled*kchorusAmount
vincr gadisto, aScaled*kdistoAmount
vincr gadelay, aScaled*kdelayAmount

			endin		
			

		/* 4. BELL INSTRUMENT */
		
		
			instr      24
/* FILTER VALUES */
kfilterCutoff chnget "filterCutoff"
kfilterResonance chnget "filterResonance"

/* FX SENDS */
krvbAmount    chnget "rvbAmountMachine"
kchorusAmount chnget "chorusAmountMachine"
kdelayAmount  chnget "delayAmountMachine"
kdistoAmount  chnget "distoAmountMachine"
kmasterVolume  chnget "volumeAmountMachine"

/* To smooth out cutoff change */
kportt linseg 0, .1, 0, 0, .1
    
    kfilterCutoff      tablei      kfilterCutoff, gicut, 1
    kfilterCutoff portk kfilterCutoff, kportt, -1

kpch cpsmid (p4)
kvel = p5	
ipch cpsmidforI (p4)
iAttackTime = p6
iReleaseTime = p7
 
kc1 = 0.2
kc2 = 1
kvdepth = 0.005
kvrate = 6

asig fmbell 0.9, ipch*4, kc1, kc2, kvdepth, kvrate


  
asig2 = asig*(kvel/127)

aenv linseg 0, iAttackTime, 0.8, iReleaseTime, 0

asig3 = asig2*aenv
 
aScaled clip	asig3,0,0dbfs
aScaled *= kmasterVolume  
  
	outs aScaled,aScaled

vincr garvbL, aScaled*krvbAmount
vincr garvbR, aScaled*krvbAmount
vincr gachorus1, aScaled*kchorusAmount
vincr gachorus2, aScaled*kchorusAmount
vincr gadisto, aScaled*kdistoAmount
vincr gadelay, aScaled*kdelayAmount

			endin	

		/* PAD */
		
		instr 31
/* FX SENDS */
krvbAmount    chnget "rvbAmountDrone"
kchorusAmount chnget "chorusAmountDrone"
kdelayAmount  chnget "delayAmountDrone"
kdistoAmount  chnget "distoAmountDrone"
kmasterVolume  chnget "volumeAmountDrone"
		
aDownExp = (1-abs(40*gaMelo));downward expander variable defined here according to the signal of the melody

kcps           cpsmid (p4+12)
kamp           =     0.9
iattack        =     p5
ivolumeEnv     =     p6
iSustain       =     p7
irelease       =     p8
kcutoff        =     p9


 aL	oscbnk	kcps,   0,   0.005*kcps,    0,     10,        rnd(1),   0,         1,       0,        0,       238,      0,       8000,      1,       1,       1,       1,       -1, gisaw,  gicos, gicos, gieqffn, gieqlfn, gieqqfn
 aR	oscbnk	kcps,   0,   0.005*kcps,    0,     10,        rnd(1),   0,        -1,       0,        0,       238,      0,       8000,      1,       1,       1,       1,       -1, gisaw,  gicos, gicos, gieqffn, gieqlfn, gieqqfn
	
	kamp	port	kamp, 0.05	
	aamp	interp	kamp		
	
	kcfoct	=	(8*kamp)+6	
	
	aL	tonex	aL, cpsoct(kcfoct),2	;APPLY LOW PASS FILTERING (TONE CONTROL)
	aR	tonex	aR, cpsoct(kcfoct),2	;APPLY LOW PASS FILTERING (TONE CONTROL)
	
kadsr	linseg 0,iattack,ivolumeEnv,iSustain,ivolumeEnv,irelease,0
	
	aL	=	aL * kadsr * aamp * 0.9	
	aR	=	aR * kadsr * aamp * 0.9
	

	kenvFilter linseg 0, 2*(p3/3), 1.0
	
aLadderL lowpass2 aL, kenvFilter*kcutoff, 1 ;APPLY LOW PASS FILTERING TO SMOOTH OUT TRANSITION IN THE SCORE
aLadderR lowpass2 aR, kenvFilter*kcutoff, 1 ;APPLY LOW PASS FILTERING TO SMOOTH OUT TRANSITION IN THE SCORE

aoutL	clip	aLadderL,0,0dbfs
aoutR	clip	aLadderR,0,0dbfs

adly delay (aoutL+aoutR), 0.002
anewDownExp lowpass2 aDownExp, 40, 1

aoutL = (aoutL+adly)*kmasterVolume*0.3
aoutR = (aoutR+adly)*kmasterVolume*0.3

	outs aoutL, aoutR
	
vincr garvbL, aoutL*krvbAmount
vincr garvbR, aoutR*krvbAmount
vincr gachorus1, aoutL*kchorusAmount
vincr gachorus2, aoutR*kchorusAmount
vincr gadisto, aoutL*kdistoAmount
vincr gadelay, aoutR*kdelayAmount

		endin



		instr 32
/* FX SENDS */
krvbAmount    chnget "rvbAmountDrone"
kchorusAmount chnget "chorusAmountDrone"
kdelayAmount  chnget "delayAmountDrone"
kdistoAmount  chnget "distoAmountDrone"
kmasterVolume  chnget "volumeAmountDrone"
		
kcps           cpsmid (p4+12)
kamp           =     0.9
iattack        =     p5
ivolumeEnv     =     p6
iSustain       =     p7
irelease       =     p8
kcutoff        =     p9		
		

kadsr	linseg 0,iattack,ivolumeEnv,iSustain,ivolumeEnv,irelease,0

kdtn		jspline		0.05, 0.4, 0.8	
kmul		rspline		0.3, 0.82, 0.04, 0.2
kamp		rspline		0.02, 3, 0.05, 0.1
a1		gbuzz		0.8*kadsr*ivolumeEnv, kcps, 75, 1, 0.5, gicos
a1		dcblock2	a1
kpan		rspline		0,1,0.1,1
a1, a2		pan2		a1, kpan
aoutL	clip	a1,0,0dbfs
aoutR	clip	a2,0,0dbfs

kenvFilter linseg 0, 2*(p3/3), 1.0
alpL lowpass2 aoutL, kenvFilter*kcutoff, 1
alpR lowpass2 aoutR, kenvFilter*kcutoff, 1

aoutL = (alpL)*0.8
aoutR = (alpR)*0.8


	outs aoutL, aoutR
	
vincr garvbL, aoutL*krvbAmount
vincr garvbR, aoutR*krvbAmount
vincr gachorus1, aoutL*kchorusAmount
vincr gachorus2, aoutR*kchorusAmount
vincr gadisto, aoutL*kdistoAmount
vincr gadelay, aoutR*kdelayAmount

		endin
			

		instr 33
/* FX SENDS */
krvbAmount    chnget "rvbAmountDrone"
kchorusAmount chnget "chorusAmountDrone"
kdelayAmount  chnget "delayAmountDrone"
kdistoAmount  chnget "distoAmountDrone"
kmasterVolume  chnget "volumeAmountDrone"

kcps           cpsmid (p4+24)
kamp           =     0.9
iattack        =     p5
ivolumeEnv     =     p6
iSustain       =     p7
irelease       =     p8
kcutoff        =     p9

kadsr	linseg 0,iattack,ivolumeEnv,iSustain,ivolumeEnv,irelease,0		

;lfo
klfo	poscil	0.2,2,1	
;hipersaw waveform
a1	vco2	0.25,kcps,0
a2	vco2	0.25,kcps+klfo,0
a3	vco2	0.4,kcps,0
a4	vco2	0.4,kcps+klfo,0

asig1 = a1 + a2
asig2 = a3 + a4

;filter	
kenvFilter linseg 0, 2*(p3/3), 1.0
alpL lowpass2 asig1, kenvFilter*kcutoff, 1
alpR lowpass2 asig2, kenvFilter*kcutoff, 1
;aout1	balance	amoog1,asig1
;aout2	balance	amoog2,asig2


aout1 = ((alpL * 0.5) + (alpR * (1 - 0.5))) *.5 * kadsr 
aout2 = ((alpL * (1-0.5)) + (alpR * 0.5))   *.5 * kadsr


aoutL = (aout1)*1.0
aoutR = (aout2)*1.0

aoutL clip aoutL,0,0dbfs
aoutR clip aoutR,0,0dbfs


	outs aoutL, aoutR
	
vincr garvbL, aoutL*krvbAmount
vincr garvbR, aoutR*krvbAmount
vincr gachorus1, aoutL*kchorusAmount
vincr gachorus2, aoutR*kchorusAmount
vincr gadisto, aoutL*kdistoAmount
vincr gadelay, aoutR*kdelayAmount

		endin

			
			/* MISC. INSTRUMENT */
			
			
			
/* COUNT INSTANCE ACTIVE */			

		instr 96
  ; Count the active instances of Instrument #1.
  gkcount active 1
  ; Print the number of active instances.
		endin
			
/* TURNOFF INSTRUMENT */

		instr 97
turnoff2 p4, 0, 1

		endin


/* TEMP MIDINOTE GENERATOR */
	instr 98
kvel   = 100 
krate  = 4
iscale = 100
  ; Random sequence from table f100
  krnd  randh int(8),krate,-1
  knote table abs(krnd),iscale
  ktrig metro 2
  if(ktrig == 1)then
  event "i", 1, 0, 1,knote, kvel
  endif
	endin 





			/* FX SECTION */


	instr 99

/* Reverb Bus */
denorm garvbL
denorm garvbR
aoutL, aoutR reverbsc garvbL*0.9, garvbR*0.9, 0.7, 15000, 44100, 0.4
aoutL dcblock aoutL
aoutR dcblock aoutR

aL clip aoutL, 0, 0dbfs
aR clip aoutR, 0, 0dbfs
outs aoutL, aoutR
clear garvbL
clear garvbR
	endin



	instr 100

/*DELAY FX*/

idelayTime chnget "delayTime"

idellevel = .5
idelayTime = 0.5
ideltime =  idelayTime
idelstereospread = .3                           ; (MAX = .5)
gadelay = gadelay * idellevel
asec delay gadelay, ideltime                  ; setup the offset to go to asig2
anit delay gadelay + gamousy, ideltime          ; calculate the first delay
asig delay gadelay + gamousy2, (ideltime * 2)    ; start the chain for asig
asig2 delay asec + gamousy, (ideltime *2)       ; start the chain for asig2
gamousy = asig * .5
gamousy2 = asig2 * .5                             ; multiplier for loop

aoutLFnl clip	asig,0,0dbfs
aoutRFnl clip	asig2,0,0dbfs
aoutAnitFnl clip	anit,0,0dbfs

	outs aoutLFnl, aoutRFnl + aoutAnitFnl

gadelay = 0
	endin



	instr 101

/*DISTORTION FX*/

denorm gadisto
kfreq  oscili 5500, 7000, 1
aout distort gadisto*0.8, 1, gifn

aoutFnl clip	aout,0,0dbfs

outs aoutFnl, aoutFnl
clear gadisto
	endin


/* Chorus UDO taken from Cabbage Zucco's example */
	opcode StChorus,aa,aakkkk

asigr,asigl,kdepth,kdepthl,krate,kratel  xin   ;legge i parametri in entrata

;ar,al  StChorus asigr,asigl,kdepth,kdepthl,krate,kratel


k1ch  randi       kdepth/2,krate,1
ar1   vdelay3 asigr,kdepth/2+k1ch,10
k2ch  randi       kdepth/2,krate*0.9,.2
ar2   vdelay3 asigr,kdepth/2+k2ch,10
k3ch  randi       kdepth/2,krate*1.1,.2
ar3   vdelay3 asigr,kdepth/2+k3ch,10
k4ch  randi       kdepth/2,krate*1.3,.1
ar4   vdelay3 asigr,kdepth/2+k4ch,10

k1chl  randi       kdepthl/2,kratel,1
ar1l   vdelay3 asigl,kdepthl/2+k1chl,10
k2chl  randi       kdepthl/2,kratel*0.9,.2
ar2l   vdelay3 asigl,kdepthl/2+k2chl,10
k3chl  randi       kdepthl/2,kratel*1.1,.2
ar3l   vdelay3 asigl,kdepthl/2+k3chl,10
k4chl  randi       kdepthl/2,kratel*1.3,.1
ar4l   vdelay3 asigl,kdepthl/2+k4chl,10


aL   =    (ar1+ar2+ar3+ar4)/2
aR  =    (ar1l+ar2l+ar3l+ar4l)/2

aoutL clip	aL,0,0dbfs
aoutR clip	aR,0,0dbfs

	xout aoutL,aoutR           ; write output

       endop

	instr	102

/* STEREO CHORUS */

k1	= 9
k2	= 2
kfxdepth	portk	k1,.01
kfxrate	portk	k2,.01

acho1,acho2	StChorus	gachorus1,gachorus2,kfxdepth,kfxdepth*.8,kfxrate,kfxrate*.8
aoutLFnl clip	acho1,0,0dbfs
aoutRFnl clip	acho2,0,0dbfs

	outs	aoutLFnl,aoutRFnl
	
clear	gachorus1,gachorus2
	endin

</CsInstruments>
<CsScore>
f1 0 4096 10 1
f2 0 4096 10 1 0 .5 0 .3 0 .1 0 .01 0 .001
f3 0 256 1 "marmstk1.wav" 0 0 0
f14 0 256 1 "fwavblnk.aiff" 0 0 0
f100 0 32 -2  48 50 52 53 55 69 71 72
i99 0 3600

; sound check



</CsScore>
</CsoundSynthesizer>


<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
