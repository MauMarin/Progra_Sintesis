MIDIClient.init
MIDIIn.connect;

~notes = Array.newClear(128);

(
SynthDef(\flute, { | gate = 1, freq = 440, amp = 1.0, a = 0.5, r = 0.2, ratio = 0.5|

    // Índice de modulador de fase; filtro del sonido
    var mod = LFCub.kr(freq:1/12).range(1, LFNoise2.kr(freq:12.0).range(1,1.02)); // flute-like sound

    // Envolvente normal que altera amplitud. Cambia calidad o granularidad del sonido
    var env = EnvGen.ar(Env.perc(a, r), doneAction:2);

    // Se aplica FM; modula frecuencia del carrier; determina pitch
    var snd = SinOsc.ar(freq * mod);

    //PMOsc(carrier, modulador, indice)
    b = PMOsc.ar(freq*snd, ratio, mod, mul:env);

	Out.ar(bus: [0,1], channelsArray:(Gate.ar(b, gate)));
}).add;
)


(
var funcOn;
funcOn = {
	arg uid, chan, note, vel;
	//[note, vel].postln;
	//var freq;

	//freq = Vibrato.kr(note.midicps,
	//	              MouseX.kr(0, 3));
	~notes[note] =
	     Synth.new(\default, [\gate, 1,
		\freq, note.midicps]);
};

MIDIIn.addFuncTo(\noteOn, funcOn);
)

(
var funcOff;
funcOff = {
	arg uid, chan, note, vel;

	~notes[note].set(\gate, 0);
	~notes[note] = nil;

};

MIDIIn.addFuncTo(\noteOff, funcOff);
)