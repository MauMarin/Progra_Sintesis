
(
SynthDef(\bell, {
	arg basefreq=300, amp=0.2;
	var out;
	out = Pan2.ar(Mix.ar(
		(SinOsc.ar(basefreq, mul:1) * SinOsc.ar(80)) +
		(SinOsc.ar(2 * basefreq, mul:0.2) * SinOsc.ar(80)) +
		(SinOsc.ar(2.3 * basefreq, mul:0.2) * SinOsc.ar(5.5) * XLine.ar(1,0.2,3)) +
		(SinOsc.ar(3.4 * basefreq, mul:0.01) * XLine.ar(1,0.1,1)) +
		(SinOsc.ar(5 * basefreq, mul:0.01) * SinOsc.ar(1) * XLine.ar(1,0.1,1))
	)* XLine.ar(1,0.001,5,doneAction:2), Rand(-0.5,0.5));
	Out.ar(0, out * amp);
}).add;
)

Synth(\bell,[\basefreq, 500]);
(
t = Task({
    50.do({ arg i;
		Synth(\bell,[\basefreq, 500]);
        4.wait;
    });
});
)
t.play()