//Rain sound//
(
SynthDef(\rain, {
	arg time=60, amp=0.8;
	var sound;
	sound = (Limiter.ar(3 * GVerb.ar(
		HPF.ar(PinkNoise.ar(0.08+LFNoise1.kr(0.3,0.02))             //Base de lluvia
			+ LPF.ar(Dust2.ar(LFNoise1.kr(0.2).range(40,50)),7000), 400)//Gotas locas
		, 250, 100, 0.25, drylevel:0.3)                             //Propiedades del GVerb
	* EnvGen.ar(Env.sine(time,1))));                                    //EnvGen Para dar Forma
	Out.ar(0, Pan2.ar(sound * amp));
}).add;
)

Synth(\rain);