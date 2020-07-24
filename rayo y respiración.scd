(
SynthDef(\thunderbolt, {
	|amp = 0.1|
	var env, m, x, sig, sig2, finalsig, out;
	out = LFNoise2.ar(20) * LFNoise2.ar(200) + LFNoise2.ar(20) * LFNoise2.ar(800);
	out = LPF.ar(out, EnvGen.ar(Env.new([300,300,800,300],[0.6,0.001,1],\exp)));
	out = out * EnvGen.ar(Env.new([0,0.1,0.1,3,0],[0.01,0.1,0.001,0.1],\sin));
	env = EnvGen.kr(Env.asr(0, 1, 0.05, 1, 0));
	m = Line.kr(0.01, 0.8, Rand(0.01, 0.04));
	x = SinOsc.ar(LFDNoise3.ar(m.range(18000, 2) ! 2) * (Rand(1, 2) * 600)) * m.exprange(1, 8) * XLine.kr(0.3, 0.0001, 5, doneAction:Done.freeSelf);
	sig = LPF.ar(FreeVerb2.ar(Impulse.ar(0),Impulse.ar(0), 1,0.95,0.4),200);
	sig = (sig*5000).tanh;
	sig = LPF.ar(sig,20000);
	sig2 = GVerb.ar(sig, 270,30,0.7,drylevel:0.5);
	finalsig = amp*env*x*(sig2+out);
	Out.ar(0, finalsig);
}).add;

SynthDef(\thunderclap,{
	var out;
	out = LFNoise2.ar(20) * LFNoise2.ar(200) + LFNoise2.ar(20) * LFNoise2.ar(800);
	out = LPF.ar(out, EnvGen.ar(Env.new([300,300,800,300],[0.6,0.001,1],\exp)));
	out = out * EnvGen.ar(Env.new([0,0.1,0.1,3,0],[0.01,0.5,0.001,5],\sin));
	Out.ar(0, Pan2.ar(out, 0));
}).add;
)

(

Tdef(\thunder, {
	loop {
		Synth("thunderclap");
		0.7.wait;
		Synth("thunderclap");
		0.7.wait;
		Synth("thunderclap");
		5.wait;
		Synth("thunderbolt", [\amp, 3]);
		0.7.wait;
		20.wait;
	}
});

)

Tdef(\thunder).play;




(
SynthDef(\breathe_in, {
	| out = 0, gate = 1, in1=0.22, in2=0.63, in3=0.18 |
	var menv = EnvGen.kr(Env.new([0,1,1,0],[in1, in2, in3], curve:'lin'), doneAction:Done.freeSelf);
	var noise = WhiteNoise.ar(0.3);
	var s1 = BPF.ar(noise, 5790, 0.1, mul:0.1);
	var s2 = BPF.ar(noise, 3400, 0.2, mul: 0.1);
	var s3 = BPF.ar(noise, 1990, 0.1, mul: 0.1);
	var s4 = BPF.ar(noise, 1250, 0.1, mul:0.1);
	Out.ar(out, menv*(s1+s2+s3+s4)!2);
}).add;

SynthDef(\breathe_out, {
	| out = 0, gate=1, out1=0.343, out2=0.387 |
	var menv = EnvGen.kr(Env.new([0, 1, 0], [out1,out2], curve:'lin'), doneAction:Done.freeSelf);
	var noise = WhiteNoise.ar(0.3);
	var s1 = BPF.ar(noise, 2290, 0.1, mul:0.1);
	var s2 = BPF.ar(noise, 1290, 0.1, mul: 0.2);
	var s3 = BPF.ar(noise, 490, 0.1, mul: 0.1);
	Out.ar(out, menv*(s1+s2+s3)!2);
}).add;
)

Tdef(\breathing, {
		loop {
			var in1 = 0.22;
			var in2 = 0.63;
			var in3 = 0.18;
			var pausein = 0.3;
			var out1 = 0.343;
			var out2 = 0.387;
			var pauseout = 0.3;
			Synth(\breathe_in, [\in1, in1, \in2, in2, \in3, in3]);
			(in1+in2+in3+pausein).wait;
			Synth(\breathe_out, [\out1, out1, \out2, out2]);
			(out1+out2+pauseout).wait;
		}
});

Tdef(\breathing).play;

