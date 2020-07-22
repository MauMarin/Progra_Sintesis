

(g =    Buffer.read(s,"C:/Users/moric/OneDrive/Documents/TEC/2020/Semestre I/Síntesis de sonido/Progra/SublSC/InvGandalf_Slow.wav");)


(
SynthDef(\vocoder, { arg out=0, rate=1, bufnum = 0, trigger=1, startPos=0, loop=1;

	var pbuf, mix, env, voice, vib;

	pbuf = PlayBuf.ar(1, g.bufnum, BufRateScale.kr(g.bufnum));

	a = BRF.ar(pbuf, SinOsc.kr(XLine.kr(400,550,2)));

	b = BPF.ar(pbuf, SinOsc.kr(XLine.kr(690,300,3)));

	c = RHPF.ar(pbuf, FSinOsc.kr(XLine.kr(0.7,300,20)), 1, 1.4);

	voice = Pan2.ar(a + b + c);

	env = Env.triangle(35, 2.6).kr();

	//mix = SinOsc.ar(Vibrato.ar(340, 6, 0.15, 0.4), 1, (voice * env));
	mix = FSinOsc.ar(340, 5, (voice * env));

	//mix = (voice * env);

	Out.ar(out, mix);

}).add;
)

(Synth(\vocoder, [out: 0]);)