MIDIClient.init;
MIDIIn.connectAll;

~notes = Array.newClear(128)
(
MIDIdef.noteOn(\noteOnTest,
	{arg vel, nn, chan, src;
		~notes[nn]=Synth.new(\flauta,[\freq,nn.midicps,\freqPh, vel.linexp(1,5,0.1,0.5),\gate,1])
});
)
(
MIDIdef.noteOff(\noteOffTest,{
	arg vel,nn;
	~notes[nn].set(\gate,0);
	~notes[nn]=nil;

});
)
MIDIdef(\noteOnTest).disable;

MIDIdef(\noteOnTest).enable;

MIDIdef(\noteOffTest).disable;

MIDIdef(\noteOffTest).enable;

(
SynthDef(\flauta, {
	| out = 0, freq = 440, amp = 1.0, freqPh = 400, gate=1|
	var env1 = EnvGen.kr(Env.new([ 0.0, 0.9, 0.9, 0.9, 0.0 ], [0.06, 0.2, 0.46, 0.2 ]));
	var air_noise = LFClipNoise.ar(freq, env1);
	var fmod = LFCub.kr(1/12, mul: 20); //parecido a LFSaw
	var env = EnvGen.ar(Env.adsr,gate, doneAction:2)*PMOsc.ar(freqPh, 2, 1.7, mul: 0.5);
	var snd = FreeVerb.ar(SinOsc.ar(freq + fmod)!2,mix:0.5,room: 0.7,damp:1,);
	Out.ar([0,1],env*((snd)*0.2));
	}).add;
)
c=Synth("flauta",[\out,0]);

(SynthDef("static",{ arg out=0;
	Out.ar(out,
		Pan2.ar(GrayNoise.ar(1)*0.1*EnvGen.kr(Env.new([[0],[3],[3],[0]],[8,4,3]),doneAction:2)
			+WhiteNoise.ar(1)*0.1*EnvGen.kr(Env.new([[0],[3],[3],[0]],[8,4,3]),doneAction:2)
			,0.0, 0.8)

	)

}).add;)


(SynthDef("wind",{ arg out=0;
	Out.ar(out,
	Pan2.ar(LPF.ar(BrownNoise.ar(1)*0.1*EnvGen.kr(Env.new([[0],[3],[3],[0]],[3,29,8]),doneAction:2))
			,0.0, 0.8)

	)

}).add;)

c=Synth("wind",[\out,0]);
d=Synth("static",[\out,0]);
d.free;