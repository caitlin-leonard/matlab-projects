clc; clear; close all;

%% --- BATTERY FAULT DETECTION SYSTEM (Multi-Layer BMS) ---

%% 1. Time Vector
t = 0:0.1:10;

%% 2. True Signals
true_voltage = 3.7 + 0.1*sin(t);
true_temp    = 30  + 5*sin(t);

%% 3. Noisy Measurements
rng(42);
measured_voltage = true_voltage + 0.05*randn(size(t));
measured_temp    = true_temp    +      randn(size(t));

%% 4. Fault Injection
measured_voltage(50:60) = 4.5;   % Overcharging fault
measured_temp(70:80)    = 60;    % Overheating fault

%% 5. Threshold-Based Detection
V_max = 4.2;  T_max = 50;
fault_V = measured_voltage > V_max;
fault_T = measured_temp    > T_max;

%% 6. Kalman Filter (Voltage Estimation)
x = 3.7; P = 1; Q = 0.001; R = 0.01;
est_voltage = zeros(size(t));
for k = 1:length(t)
    Pp = P + Q;
    K  = Pp / (Pp + R);
    x  = x + K*(measured_voltage(k) - x);
    P  = (1 - K)*Pp;
    est_voltage(k) = x;
end

%% 7. Kalman Residual Fault
err = abs(measured_voltage - est_voltage);
fault_K = err > 0.2;

%% 8. Rate-of-Change Fault
dV = [0, diff(measured_voltage)];
fault_R = abs(dV) > 0.3;

%% 9. Final Fault Decision (Logical OR)
fault_final = fault_V | fault_T | fault_K | fault_R;

%% 10. Plots
figure('Name','Battery Fault Detection','NumberTitle','off','Color','w');

% Subplot 1: Voltage
subplot(3,1,1);
plot(t, measured_voltage, 'r-', 'LineWidth', 1.2); hold on;
plot(t, est_voltage,      'b-', 'LineWidth', 1.5);
yline(V_max, '--', 'Color', [1 0.5 0], 'LineWidth', 1.2, 'Label', 'V_{max}=4.2V');
plot(t(fault_final), measured_voltage(fault_final), 'MarkerSize', 5, 'MarkerFaceColor','k');
legend('Measured','Kalman Est.','Fault','Location','northeast','FontSize',8);
ylabel('Voltage (V)'); title('Voltage Fault Detection'); grid on;

% Subplot 2: Temperature
subplot(3,1,2);
plot(t, measured_temp, 'm-', 'LineWidth', 1.2); hold on;
yline(T_max, '--', 'Color', [1 0.5 0], 'LineWidth', 1.2, 'Label', 'T_{max}=50°C');
plot(t(fault_T), measured_temp(fault_T), 'MarkerSize', 5, 'MarkerFaceColor','g');
legend('Temperature','Temp Fault','Location','northeast','FontSize',8);
ylabel('Temp (°C)'); title('Temperature Fault Detection'); grid on;

% Subplot 3: Kalman Error
subplot(3,1,3);
plot(t, err, 'k-', 'LineWidth', 1.2); hold on;
yline(0.2, 'r--', 'LineWidth', 1.5, 'Label', 'Threshold = 0.2');
x_fill = [t, fliplr(t)];
y_fill = [max(err, 0.2), fliplr(repmat(0.2, size(t)))];
fill(x_fill, y_fill, 'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
ylabel('|Error| (V)'); xlabel('Time (s)'); title('Kalman Residual Error'); grid on;
legend('Residual','Threshold','Fault Zone','FontSize',8);

sgtitle('Battery Fault Detection — Multi-Layer BMS','FontSize',13,'FontWeight','bold');