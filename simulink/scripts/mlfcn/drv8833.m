function [in1, in2, in3, in4] = drv8833(uL, uR, brkL, brkR)
% DRV8833 DRIVER - per motor: forward = (PWM, 0), reverse = (0, PWM),
% brake = (255, 255), coast = (0, 0). Duty 0..255 for the Arduino PWM blocks.
% The brake bypasses the soft-start ramp: it acts immediately.
[in1, in2] = bridge(dirLeft*uL,  brkL, pwmMin, pwmMax);
[in3, in4] = bridge(dirRight*uR, brkR, pwmMin, pwmMax);
end

function [a, b] = bridge(u, brk, pMin, pMax)
a = uint8(0); b = uint8(0);
if brk
    a = uint8(255); b = uint8(255);
elseif abs(u) > 0.02
    duty = uint8(round(255*(pMin + (pMax - pMin)*min(abs(u), 1))));
    if u > 0
        a = duty;
    else
        b = duty;
    end
end
end
