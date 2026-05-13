<h2 align="center">🔋 Battery Fault Detection</h2>
<p align="center">
  Multi-layer battery fault detection system in MATLAB —
  combining Kalman filtering, threshold-based detection, and rate-of-change analysis
  to identify overcharging and overheating faults in a simulated battery pack.
</p>

<hr>

<h3>🧠 Overview</h3>
<p>
This script simulates a Battery Management System (BMS) fault detection pipeline.
True voltage and temperature signals are generated, corrupted with noise, and then
injected with faults. Four detection layers are applied and combined using a logical OR
to produce a final fault flag.
</p>

<hr>

<h3>⚙️ Detection Layers</h3>
<table>
  <tr><th>Layer</th><th>Method</th><th>Detects</th></tr>
  <tr><td>1</td><td>Voltage threshold (V &gt; 4.2V)</td><td>Overcharging fault</td></tr>
  <tr><td>2</td><td>Temperature threshold (T &gt; 50°C)</td><td>Overheating fault</td></tr>
  <tr><td>3</td><td>Kalman filter residual (&gt; 0.2V)</td><td>Sudden anomalies in voltage</td></tr>
  <tr><td>4</td><td>Rate-of-change (dV &gt; 0.3V/step)</td><td>Rapid voltage spikes</td></tr>
</table>
<p>Final fault = Layer 1 OR Layer 2 OR Layer 3 OR Layer 4</p>

<hr>

<h3>💉 Fault Injection</h3>
<pre><code>measured_voltage(50:60) = 4.5;   % Overcharging fault at t = 5–6s
measured_temp(70:80)    = 60;    % Overheating fault at t = 7–8s
</code></pre>

<hr>

<h3>📊 Output Plots</h3>
<p align="center">
  <img src="Battery Fault Detection.png" width="700"/>
</p>
<ul>
  <li><b>Subplot 1</b> — Measured vs Kalman-estimated voltage with fault markers</li>
  <li><b>Subplot 2</b> — Temperature with overheating fault highlighted</li>
  <li><b>Subplot 3</b> — Kalman residual error with fault zone shaded in red</li>
</ul>

<hr>

<h3>▶️ How to Run</h3>
<pre><code>% Open MATLAB and run:
battery_fault_detection.m
</code></pre>

<hr>

<h3>🛠️ Requirements</h3>
<ul>
  <li>MATLAB (no additional toolboxes required)</li>
</ul>
