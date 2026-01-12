#!/bin/bash

# Этот скрипт настраивает конфигурацию tmux и Neovim (LazyVim).

# Цветовые коды
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # Без цвета

# Функция для вывода сообщений
info() {
    echo -e "${GREEN}[ИНФО]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[ПРЕДУПРЕЖДЕНИЕ]${NC} $1"
}

error() {
    echo -e "${RED}[ОШИБКА]${NC} $1"
}

# --- Проверка зависимостей ---
info "Проверка зависимостей..."
# Общая проверка для менеджеров пакетов
if command -v apt-get &> /dev/null; then
    PKG_MANAGER="sudo apt-get install -y"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="sudo dnf install -y"
elif command -v pacman &> /dev/null; then
    PKG_MANAGER="sudo pacman -S --noconfirm"
elif command -v brew &> /dev/null; then
    PKG_MANAGER="brew install"
else
    error "Не удалось определить менеджер пакетов. Пожалуйста, установите git, tmux и neovim вручную."
    exit 1
fi

# Проверка и установка зависимостей
for cmd in git tmux nvim; do
    if ! command -v $cmd &> /dev/null; then
        warn "$cmd не установлен. Попытка установки..."
        $PKG_MANAGER $cmd
        if ! command -v $cmd &> /dev/null; then
            error "Не удалось установить $cmd. Пожалуйста, установите его вручную и перезапустите скрипт."
            exit 1
        fi
    else
        info "$cmd уже установлен."
    fi
done

# --- Настройка Tmux ---
info "Настройка tmux..."

# Резервное копирование существующей конфигурации tmux
if [ -f "$HOME/.tmux.conf" ]; then
    warn "Найден существующий ~/.tmux.conf. Создается резервная копия в ~/.tmux.conf.bak"
    mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak"
fi

# Копирование конфигурации tmux
info "Копирование .tmux.conf в домашний каталог..."
cp ".tmux.conf" "$HOME/.tmux.conf"

# Установка TPM (Tmux Plugin Manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    info "Установка TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
    info "TPM уже установлен."
fi

# --- Настройка Neovim (LazyVim) ---
info "Настройка Neovim (LazyVim)..."

# Резервное копирование существующей конфигурации nvim
if [ -d "$HOME/.config/nvim" ]; then
    warn "Найдена существующая конфигурация ~/.config/nvim. Создается резервная копия в ~/.config/nvim.bak"
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
fi

# Копирование конфигурации nvim
info "Копирование конфигурации nvim в ~/.config/nvim..."
cp -r "nvim" "$HOME/.config/nvim"

# --- Заключительные инструкции ---
info "Настройка завершена!"
echo
info "Следующие шаги:"
info "1. Запустите tmux: \`tmux\`"
info "2. Внутри tmux нажмите \`prefix + I\` (заглавная 'i'), чтобы установить плагины. "
info "   (Префикс по умолчанию - \`Ctrl+b\`. Если вы его изменили, используйте свой префикс.)"
info "3. Запустите Neovim: \`nvim\`"
info "   Lazy.nvim автоматически установит все плагины при первом запуске."
echo
info "Приятного пользования вашей новой средой!"
