MIDIClient.init;

m = MIDIOut(1);

(
SynthDef(\heartbeat, {
	arg amp = 5;
	var out;
	out = Pan2.ar(Mix.ar(
		LFNoise2.ar(300) * EnvGen.ar(Env.new([0,0.5,0,0,0.5,0],[0.05,0.05,0.3,0.05,0.05],\sin))
	));
	Out.ar(0, out * amp);
}).add;
)

Synth(\heartbeat)

(
a = Task({
    50.do({ arg i;
		m.noteOn(0, 10, 0);
		Synth(\heartbeat);
        1.2.wait;
		m.noteOn(0, 10, 0);
    });
});
)
a.play();
