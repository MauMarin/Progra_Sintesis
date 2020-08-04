//Mod para la guitarra o para la voz//
(
x = {
	var sig, rmod, out;
	sig = SoundIn.ar(0!2);
	sig = sig + sig*SinOsc.ar(MouseX.kr(100,1000));
	out = sig + GVerb.ar(sig*EnvGen.ar
		(Env.sine(MouseY.kr(0,3))),MouseY.kr(0,10));
	out = out + DelayN.ar(sig, 0.5,MouseY.kr(0.1,0.4));
	Out.ar(0, out*0.2);
}.play;
)



