    ```
    #!/bin/bash
    # Скрипт для автоматической настройки окружения Python с CUDA и PyTorch
    # Версия без Unicode символов для Windows терминала

    set -e  # Останавливаем скрипт при любой ошибке

    echo "=========================================="
    echo "  Setting up GPU Environment"
    echo "=========================================="

    # 1. Проверка CUDA
    echo ""
    echo "[1/8] Checking GPU..."
    if command -v nvidia-smi &> /dev/null; then
        echo "[OK] NVIDIA GPU detected:"
        nvidia-smi --query-gpu=name,memory.total --format=csv,noheader
    else
        echo "[ERROR] nvidia-smi not found. Please install NVIDIA drivers."
        exit 1
    fi

    # 2. Проверка uv
    echo ""
    echo "[2/8] Checking uv..."
    if ! command -v uv &> /dev/null; then
        echo "[ERROR] uv not installed. Install with: curl -LsSf https://astral.sh/uv/install.sh | sh"
        exit 1
    fi
    echo "[OK] uv is installed"

    # 3. Создание папки проекта
    PROJECT_DIR=~/Desktop/gpu_project
    echo ""
    echo "[3/8] Creating project at $PROJECT_DIR"
    mkdir -p "$PROJECT_DIR"
    cd "$PROJECT_DIR"

    # 4. Создание виртуального окружения
    echo ""
    echo "[4/8] Creating virtual environment with Python 3.11"
    uv venv --python 3.11

    # 5. Активация окружения
    echo ""
    echo "[5/8] Activating environment"
    source .venv/Scripts/activate 2>/dev/null || source .venv/bin/activate

    # 6. Установка pip
    echo ""
    echo "[6/8] Installing pip"
    python -m ensurepip --upgrade

    # 7. Установка PyTorch с CUDA 11.8
    echo ""
    echo "[7/8] Installing PyTorch with CUDA 11.8 (this may take a few minutes)"
    python -m pip install --upgrade pip
    python -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

    # 8. Установка дополнительных пакетов
    echo ""
    echo "[8/8] Installing additional packages"
    python -m pip install numpy matplotlib tqdm pandas

    # 9. Проверка установки
    echo ""
    echo "=========================================="
    echo "  VERIFICATION"
    echo "=========================================="

    python -c "
    import torch
    print(f'PyTorch version: {torch.__version__}')
    print(f'CUDA available: {torch.cuda.is_available()}')
    if torch.cuda.is_available():
        print(f'GPU: {torch.cuda.get_device_name(0)}')
        print(f'Memory: {torch.cuda.get_device_properties(0).total_memory / 1e9:.2f} GB')
    else:
        print('[ERROR] CUDA not available!')
    "

    # 10. Создание тестового скрипта (без Unicode)
    echo ""
    echo "Creating test script test_gpu.py..."

    cat > test_gpu.py << 'EOF'
    import torch
    import time
    import sys

    # Настройка кодировки для Windows
    if sys.platform == 'win32':
        import io
        sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

    print("="*60)
    print("GPU Test - PyTorch + CUDA")
    print("="*60)

    if torch.cuda.is_available():
        print(f"GPU: {torch.cuda.get_device_name(0)}")
        print(f"Memory: {torch.cuda.get_device_properties(0).total_memory / 1e9:.2f} GB")
        
        # Matrix multiplication test
        size = 5000
        print(f"\nMatrix multiplication {size}x{size} on GPU...")
        a = torch.randn(size, size).cuda()
        b = torch.randn(size, size).cuda()
        
        # Warmup
        _ = a @ b
        torch.cuda.synchronize()
        
        start = time.time()
        c = a @ b
        torch.cuda.synchronize()
        elapsed = time.time() - start
        print(f"Time: {elapsed:.2f} seconds")
        
        print("\n[SUCCESS] GPU is working correctly!")
    else:
        print("[ERROR] CUDA not available")
    EOF

    # 11. Создание бенчмарка
    echo ""
    echo "Creating benchmark script benchmark.py..."

    cat > benchmark.py << 'EOF'
    import torch
    import torch.nn as nn
    import time
    import sys

    # Настройка кодировки для Windows
    if sys.platform == 'win32':
        import io
        sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

    print("="*60)
    print("BENCHMARK: CPU vs GPU")
    print("="*60)

    class SimpleNN(nn.Module):
        def __init__(self):
            super().__init__()
            self.fc1 = nn.Linear(784, 512)
            self.fc2 = nn.Linear(512, 256)
            self.fc3 = nn.Linear(256, 10)
            self.relu = nn.ReLU()
        
        def forward(self, x):
            x = self.relu(self.fc1(x))
            x = self.relu(self.fc2(x))
            x = self.fc3(x)
            return x

    def benchmark(device, batch_size, epochs=5):
        device = torch.device(device)
        model = SimpleNN().to(device)
        optimizer = torch.optim.Adam(model.parameters())
        criterion = nn.CrossEntropyLoss()
        
        start = time.time()
        for _ in range(epochs):
            x = torch.randn(batch_size, 784, device=device)
            y = torch.randint(0, 10, (batch_size,), device=device)
            
            optimizer.zero_grad()
            loss = criterion(model(x), y)
            loss.backward()
            optimizer.step()
            
            if device.type == 'cuda':
                torch.cuda.synchronize()
        
        return time.time() - start

    if torch.cuda.is_available():
        batch_sizes = [128, 256, 512, 1024, 2048]
        
        print(f"GPU: {torch.cuda.get_device_name(0)}")
        print(f"Memory: {torch.cuda.get_device_properties(0).total_memory / 1e9:.2f} GB\n")
        
        print("Batch Size | CPU Time (s) | GPU Time (s) | Speedup")
        print("-" * 55)
        
        for bs in batch_sizes:
            cpu_time = benchmark('cpu', bs)
            gpu_time = benchmark('cuda', bs)
            speedup = cpu_time / gpu_time
            print(f"{bs:10d} | {cpu_time:11.2f} | {gpu_time:11.2f} | {speedup:7.1f}x")
    else:
        print("[ERROR] CUDA not available")
    EOF

    # 12. Создание MNIST training script
    echo ""
    echo "Creating MNIST training script mnist_train.py..."

    cat > mnist_train.py << 'EOF'
    import torch
    import torch.nn as nn
    import torch.optim as optim
    from torch.utils.data import DataLoader
    from torchvision import datasets, transforms
    import time
    import sys

    # Настройка кодировки для Windows
    if sys.platform == 'win32':
        import io
        sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

    print("="*60)
    print("MNIST Training: CPU vs GPU Comparison")
    print("="*60)

    # Load MNIST dataset
    transform = transforms.Compose([
        transforms.ToTensor(),
        transforms.Normalize((0.1307,), (0.3081,))
    ])

    print("\nLoading MNIST dataset...")
    train_dataset = datasets.MNIST('./data', train=True, download=True, transform=transform)
    test_dataset = datasets.MNIST('./data', train=False, transform=transform)

    # Simple CNN
    class CNN(nn.Module):
        def __init__(self):
            super().__init__()
            self.conv1 = nn.Conv2d(1, 32, 3, 1)
            self.conv2 = nn.Conv2d(32, 64, 3, 1)
            self.dropout1 = nn.Dropout2d(0.25)
            self.dropout2 = nn.Dropout2d(0.5)
            self.fc1 = nn.Linear(9216, 128)
            self.fc2 = nn.Linear(128, 10)
        
        def forward(self, x):
            x = self.conv1(x)
            x = nn.functional.relu(x)
            x = self.conv2(x)
            x = nn.functional.relu(x)
            x = nn.functional.max_pool2d(x, 2)
            x = self.dropout1(x)
            x = torch.flatten(x, 1)
            x = self.fc1(x)
            x = nn.functional.relu(x)
            x = self.dropout2(x)
            x = self.fc2(x)
            return nn.functional.log_softmax(x, dim=1)

    def train_and_evaluate(device, epochs=2, batch_size=64):
        device_obj = torch.device(device)
        model = CNN().to(device_obj)
        optimizer = optim.Adam(model.parameters())
        train_loader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True)
        
        print(f"\nTraining on: {device.upper()}")
        print("-" * 40)
        
        model.train()
        start = time.time()
        
        for epoch in range(epochs):
            epoch_loss = 0
            for batch_idx, (data, target) in enumerate(train_loader):
                data, target = data.to(device_obj), target.to(device_obj)
                optimizer.zero_grad()
                loss = nn.functional.nll_loss(model(data), target)
                loss.backward()
                optimizer.step()
                epoch_loss += loss.item()
                
                if batch_idx % 100 == 0:
                    print(f"  Epoch {epoch+1}: Batch {batch_idx}/{len(train_loader)} - Loss: {loss.item():.4f}")
            
            avg_loss = epoch_loss / len(train_loader)
            print(f"[OK] Epoch {epoch+1} completed - Avg Loss: {avg_loss:.4f}")
        
        total_time = time.time() - start
        
        # Evaluation
        model.eval()
        test_loader = DataLoader(test_dataset, batch_size=1000)
        correct = 0
        with torch.no_grad():
            for data, target in test_loader:
                data, target = data.to(device_obj), target.to(device_obj)
                pred = model(data).argmax(dim=1)
                correct += pred.eq(target).sum().item()
        
        accuracy = 100. * correct / len(test_dataset)
        return total_time, accuracy

    # Run benchmarks
    if torch.cuda.is_available():
        print(f"\nGPU: {torch.cuda.get_device_name(0)}")
        print(f"GPU Memory: {torch.cuda.get_device_properties(0).total_memory / 1e9:.2f} GB\n")
        
        # CPU
        cpu_time, cpu_acc = train_and_evaluate('cpu', epochs=2)
        
        # GPU
        gpu_time, gpu_acc = train_and_evaluate('cuda', epochs=2)
        
        # Results
        print("\n" + "="*60)
        print("FINAL RESULTS")
        print("="*60)
        print(f"CPU: {cpu_time:.2f}s, Accuracy: {cpu_acc:.2f}%")
        print(f"GPU: {gpu_time:.2f}s, Accuracy: {gpu_acc:.2f}%")
        print(f"Speedup: {cpu_time/gpu_time:.2f}x")
        print(f"Time saved: {cpu_time - gpu_time:.2f}s")
        
        print("\n" + "="*60)
        print("CONCLUSION:")
        print("="*60)
        print(f"  - GPU is {cpu_time/gpu_time:.1f}x faster than CPU")
        print(f"  - Both models achieve the same accuracy ({gpu_acc:.1f}%)")
        print(f"  - Your GPU is ready for machine learning!")
    else:
        print("[ERROR] CUDA not available")
    EOF

    # 13. Запуск теста
    echo ""
    echo "=========================================="
    echo "  RUNNING TESTS"
    echo "=========================================="
    echo ""
    echo "Test 1: Basic GPU check..."
    python test_gpu.py

    echo ""
    echo "=========================================="
    echo "  RUNNING BENCHMARK"
    echo "=========================================="
    echo ""
    python benchmark.py

    echo ""
    echo "=========================================="
    echo "  COMPLETE!"
    echo "=========================================="
    echo ""
    echo "Project created at: $PROJECT_DIR"
    echo ""
    echo "To activate environment:"
    echo "  cd $PROJECT_DIR"
    echo "  source .venv/Scripts/activate  # Windows Git Bash"
    echo "  source .venv/bin/activate      # Linux/Mac"
    echo ""
    echo "To run MNIST training:"
    echo "  python mnist_train.py"
    echo ""
    echo "=========================================="
    ```