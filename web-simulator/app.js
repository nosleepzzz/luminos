document.addEventListener('DOMContentLoaded', () => {
  // Clock
  const macClock = document.getElementById('mac-clock');
  function updateClock() {
    const now = new Date();
    const options = { weekday: 'short', month: 'short', day: 'numeric', hour: 'numeric', minute: '2-digit' };
    macClock.textContent = now.toLocaleDateString('en-US', options);
  }
  setInterval(updateClock, 1000);
  updateClock();

  // Control Center Popover Toggle
  const btnCC = document.getElementById('btn-control-center');
  const ccPopover = document.getElementById('control-center-popover');
  
  btnCC.addEventListener('click', (e) => {
    e.stopPropagation();
    ccPopover.classList.toggle('hidden');
  });

  document.addEventListener('click', (e) => {
    if (!ccPopover.contains(e.target) && e.target !== btnCC) {
      ccPopover.classList.add('hidden');
    }
  });

  // Window Focus & Dragging
  let highestZIndex = 100;
  const windows = document.querySelectorAll('.mac-window');
  
  windows.forEach(win => {
    win.addEventListener('mousedown', () => {
      highestZIndex++;
      win.style.zIndex = highestZIndex;
      windows.forEach(w => w.classList.remove('focused'));
      win.classList.add('focused');
      
      const title = win.querySelector('.window-title').textContent.trim();
      document.getElementById('current-app-name').textContent = title.split('—')[0].trim();
    });

    const header = win.querySelector('.window-header');
    let isDragging = false;
    let offsetX = 0, offsetY = 0;

    header.addEventListener('mousedown', (e) => {
      if (e.target.closest('.traffic-lights')) return;
      isDragging = true;
      offsetX = e.clientX - win.offsetLeft;
      offsetY = e.clientY - win.offsetTop;
    });

    document.addEventListener('mousemove', (e) => {
      if (!isDragging) return;
      win.style.left = `${e.clientX - offsetX}px`;
      win.style.top = `${e.clientY - offsetY}px`;
    });

    document.addEventListener('mouseup', () => {
      isDragging = false;
    });
  });

  // Traffic Light Controls
  document.querySelectorAll('.light.close').forEach(btn => {
    btn.addEventListener('click', () => {
      const targetId = btn.getAttribute('data-close');
      const targetWin = document.getElementById(targetId);
      if (targetWin) targetWin.classList.add('minimized');
    });
  });

  document.querySelectorAll('.dock-item').forEach(item => {
    item.addEventListener('click', () => {
      const app = item.getAttribute('data-open');
      if (!app) return;
      
      const win = document.getElementById(app);
      if (win) {
        win.classList.remove('minimized');
        highestZIndex++;
        win.style.zIndex = highestZIndex;
        windows.forEach(w => w.classList.remove('focused'));
        win.classList.add('focused');
      }
    });
  });

  // Interactive Flavor Switcher Logic
  const flavorLabel = document.getElementById('flavor-label');
  const idleRamVal = document.getElementById('idle-ram-val');

  const FLAVORS = {
    glass: { name: '🍏 Glass Edition', ram: 'RAM ~420 MB' },
    lite:  { name: '⚡ Lite Edition',  ram: 'RAM < 280 MB' },
    game:  { name: '🎮 GameDeck Edition', ram: 'RAM ~500 MB' },
    work:  { name: '🏢 Workstation Edition', ram: 'RAM ~550 MB' }
  };

  function setFlavor(key) {
    const f = FLAVORS[key];
    flavorLabel.textContent = `Flavor: ${f.name}`;
    idleRamVal.textContent = f.ram;
    document.querySelectorAll('[id^="btn-flavor-"]').forEach(b => b.classList.remove('primary'));
    document.getElementById(`btn-flavor-${key}`).classList.add('primary');
  }

  document.getElementById('btn-flavor-glass').addEventListener('click', () => setFlavor('glass'));
  document.getElementById('btn-flavor-lite').addEventListener('click', () => setFlavor('lite'));
  document.getElementById('btn-flavor-game').addEventListener('click', () => setFlavor('game'));
  document.getElementById('btn-flavor-work').addEventListener('click', () => setFlavor('work'));

  // Terminal Simulator
  const termInput = document.getElementById('term-input');
  const termOutput = document.getElementById('terminal-output');

  const COMMANDS = {
    help: `LuminOS Commands:
  • <span class="cmd-keyword">lumin-fetch</span>             - Display LuminOS specs & star logo
  • <span class="cmd-keyword">lumin --status</span>          - Show system control center & active flavor
  • <span class="cmd-keyword">lumin-powerd</span>            - Run battery & thermal daemon
  • <span class="cmd-keyword">lumin-security --audit</span>  - Run security sandbox audit
  • <span class="cmd-keyword">uname -r</span>                 - Print kernel version
  • <span class="cmd-keyword">clear</span>                    - Clear terminal output`,
    
    "lumin-fetch": `<pre style="color: #eab308; line-height: 1.2; font-family: monospace;">
         /\\       
        /  \\      <span style="color:#38bdf8">lumin</span>@<span style="color:#38bdf8">lumin-universal</span>
       / /\\ \\     -------------------------------
      / /  \\ \\    OS:        LuminOS v1.0 (Universal Universal Linux)
     / / /\\ \\ \\   Kernel:    Linux 6.10.5-1-lumin
    / / /  \\ \\ \\  Idle RAM:  ~280 MB - 420 MB (Ultra-Light Footprint)
   /_/_/____\\_\\_\\ ZRAM:      ZSTD 2.5x Compression Enabled
                  Target:    Universal (Laptops, Low-Spec PCs, Handhelds, Workstations)
                  Scheduler: BORE + eBPF scx_lavd
</pre>`,

    "lumin --status": `========================================================
     🌟 LuminOS - Universal System Control Center       
========================================================
  • Distro Name:     LuminOS (Universal Linux Edition)
  • Flavors:         Glass (~420MB), Lite (<280MB), GameDeck (~500MB), Pro (~550MB)
  • Battery Daemon:  lumin-powerd (Auto AC/BAT Switch)
  • Security Engine: Bubblewrap Sandbox (lumin-security)
  • Windows Killer:  Built-in Wine-GE / Proton-Lumin EXE runner
========================================================`,

    "lumin-powerd": `[lumin-powerd] 🔋 Battery Active: Lumin Low-Power Mode Enabled
   └─ CPU Governor -> powersave (Dynamic P-State active)
   └─ PCIe ASPM    -> Deep C-States (C8/C10 enabled)
   └─ GPU Mode     -> Integrated iGPU Low-Frequency Offload`,

    "lumin-security --audit": `========================================================
  🛡️ LuminOS - Security & Hardening Control Audit       
========================================================
  • Kernel Hardening:  sysctl (kptr_restrict=2, dmesg_restrict=1)
  • eBPF Hardening:    unprivileged_bpf_disabled=1
  • Process Security:  Yama Ptrace Scope 2 (Anti-memory inspection)
  • EXE Sandbox Mode:  Bubblewrap (bwrap) Unprivileged Container
  • Firewall State:    Stealth Mode (Default Deny Incoming)
  • MAC System:        AppArmor Profiles Active
========================================================`,

    "uname -r": "6.10.5-1-lumin-universal-x86_64"
  };

  termInput.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') {
      const cmd = termInput.value.trim();
      if (!cmd) return;

      const line = document.createElement('div');
      line.className = 'term-line';
      line.innerHTML = `<span class="prompt">lumin@laptop ~$</span> ${cmd}`;
      termOutput.appendChild(line);

      const respLine = document.createElement('div');
      respLine.className = 'term-line';

      if (cmd === 'clear') {
        termOutput.innerHTML = '';
      } else if (COMMANDS[cmd]) {
        respLine.innerHTML = COMMANDS[cmd];
        termOutput.appendChild(respLine);
      } else {
        respLine.innerHTML = `<span style="color: #ef4444;">zsh: command not found: ${cmd}</span>. Type <span class="cmd-keyword">'help'</span> for commands.`;
        termOutput.appendChild(respLine);
      }

      termInput.value = '';
      termOutput.scrollTop = termOutput.scrollHeight;
    }
  });

  // Windows App Runner Button
  const btnRunExe = document.getElementById('btn-run-exe');
  const exeInput = document.getElementById('exe-input');
  const exeStatus = document.getElementById('exe-output-status');

  btnRunExe.addEventListener('click', () => {
    const filename = exeInput.value || 'OfficeSetup.exe';
    exeStatus.style.color = '#007aff';
    exeStatus.textContent = `[LuminWin] Launching ${filename} in Bubblewrap sandbox with Proton-Lumin & DXVK...`;

    setTimeout(() => {
      exeStatus.style.color = '#10b981';
      exeStatus.textContent = `✅ ${filename} launched securely in sandboxed prefix ~/.lumin-win!`;
    }, 1200);
  });

  // Battery / Power buttons
  document.getElementById('btn-bat-mode').addEventListener('click', () => {
    document.getElementById('battery-status').querySelector('.val').textContent = '🔋 94% (BAT)';
    alert('Switched to Battery Saver Profile (Deep C-States C8/C10 enabled)!');
  });

  document.getElementById('btn-ac-mode').addEventListener('click', () => {
    document.getElementById('battery-status').querySelector('.val').textContent = '⚡ 94% (AC)';
    alert('Switched to Peak AC Performance Profile!');
  });
});
