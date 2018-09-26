%Demo code to control output triggers on one 8-bit port of a Measurement
%Computing device.

%USB DAQ, Measurement Computing USB-1208FS:
%Two ports, A & B, each has 8 wires/bits.
%Each port is read/written separately, taking a decimal value 0-255.
%The value is output as a 8-digit binary number, with least significant
%digit running through the wire on the right end of the row.
%(the command DaqPins prints out a full map of the terminals)

%info for EEG trigger input, Biosemi Active2 USB2 Receiver:
%In the lab setup, lines from DAQ port A are wired into the
%least-significant bits of the Biosemi receiver (red wires).
%Display and analysis software usually reads all 16 wires/bits together,
%as a value 0-65535. So if you intend to use only the eight lines in port A,
%you still have to make sure that port B is set to zero.

function Send_TRIGGER(daqInd, trigger_Output)
%settings

portNum = 0;

%send trigger
DaqDOut(daqInd(1),portNum,trigger_Output);    %set wires to binary representation of triggerValue
WaitSecs(.006);  % make sure trigger lasts long enough for the machine to catch it.  If processing time is tight, alternative is to move the next line's reset command to end of trial.
DaqDOut(daqInd(1),portNum,0);

WaitSecs(.006);  % make sure trigger lasts long enough for the machine to catch it.  If processing time is tight, alternative is to move the next line's reset command to end of trial.
DaqDOut(daqInd(1),portNum,128);    %set wires to binary representation of triggerValue
WaitSecs(.006);  % make sure trigger lasts long enough for the machine to catch it.  If processing time is tight, alternative is to move the next line's reset command to end of trial.
DaqDOut(daqInd(1),portNum,0);

end
