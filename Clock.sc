//Clock//
(
SynthDef(\clock, {
	arg time=60,note=8000;
	var out;
	out = LFNoise2.ar(note) * SinOsc.ar(note / 2) * EnvGen.ar(Env.new([0,0.35,0.25,1,0.5,0.75,0.5,0],[0.01,0.01,0.01,0.01,0.01,0.01,0.04],\sin));
	Out.ar(0, Pan2.ar(out));
}).add;
)

(
Pbind(
	\instrument, "clock",
	\note, Pseq([4200, 4000], inf),
	\dur, 1
).play
)

