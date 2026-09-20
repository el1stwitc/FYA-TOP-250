import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

/**
 * Конфигурация для тестов. Держится отдельно от vite.config.ts, чтобы
 * не тащить тестовые настройки в прод-сборку.
 */
export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'happy-dom',
    // Модалки рендерятся в портал document.body — очищаем DOM между тестами.
    clearMocks: false,
    include: ['tests/**/*.test.ts', 'tests/**/*.test.tsx'],
    globals: false,
    restoreMocks: true,
  },
});
