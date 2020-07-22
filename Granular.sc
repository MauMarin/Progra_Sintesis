// ***************************************************** VOICE *********************************************************************

(b = Buffer.read(s, "C:/Users/moric/OneDrive/Documents/TEC/2020/Semestre I/Síntesis de sonido/Progra/SublSC/Audio/Message1.wav") ;)

(
SynthDef(\grain,
{
	arg gate = 1, amp = 1, size = 3, buffer, sampleRate, bufnum = -1, mul = 1;

	var pan, env, freqdev;

	env = EnvGen.kr(Env([0, 1, 0], [1, 1], \sin, 1),1, doneAction: Done.freeSelf) * mul;
	pan = FSinOsc.kr(3);

    Out.ar(0,
			GrainBuf.ar(2, Impulse.ar(MouseX.kr(1,25)), size, buffer, BufRateScale.kr(b),
            GrayNoise.kr(0.1).range(0, 4), 7.1, pan, -2.9) * env, \envbufnum, 5)
}).add;
)

(x = Synth(\grain , [\buffer , b, \size, 0.6, \amp, 0.5, \bufnum, 5.7, \mul, 0.1]) ;)


// ***************************************************** MUSIC *********************************************************************

(

var w, rateslid, trigslid, startposslid, loopslid, a;



a = Synth(\playbuf, [\out, 0, \bufnum, b.bufnum]);



w = Window("PlayBuf Example",Rect(10,200,300,150));



w.front;


w.view.decorator= FlowLayout(w.view.bounds);


rateslid = EZSlider(w, 250@24, "Rate", ControlSpec(0.5, 10, 'exponential', 0.1), {|ez| a.set(\rate,ez.value)}, 1);


trigslid = EZSlider(w, 250@24, "Trigger", ControlSpec(0, 1, 'lin', 1), {|ez| a.set(\trigger,ez.value)}, 1);


startposslid= EZSlider(w, 250@24, "StartPos", ControlSpec(0.0, 1.0, 'lin', 0.01), {|ez| a.set(\startPos,ez.value)}, 0);


loopslid= EZSlider(w, 250@24, "Loop", ControlSpec(0, 1, 'lin', 0.1), {|ez| a.set(\loop,ez.value)}, 1);


w.onClose_({a.free;});

)