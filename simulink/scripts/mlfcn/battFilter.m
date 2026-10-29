function v = battFilter(raw)
% BATTERY VOLTAGE - raw ADC count on A0 -> battery voltage [V], smoothed by a
% first-order low-pass (time constant tauBatt) so that motor start-up dips
% do not send the robot to Deep_Sleep. Starts directly at the first reading.
persistent y
vin = double(raw)*vRef/adcMax;
if isempty(y), y = vin; end
y = y + (Ts/tauBatt)*(vin - y);
v = y;
end
