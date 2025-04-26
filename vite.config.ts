import { defineConfig, createLogger } from 'vite'
import elm from 'vite-plugin-elm'

const logger = createLogger()
const { warn } = logger

logger.warn = (msg, options) => {
  // there is a weird warning from the plugin even though HMR is working fine, so we can ignore it for now
  if (/warning: Failed to resolve "(.*\.elm)?"/.test(msg)) {
    return
  }

  warn(msg, options)
}

export default defineConfig({
  resolve: {
    extensions: ['.js', '.ts', '.elm', '.json'],
  },
  plugins: [elm()],
  customLogger: logger,
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: ['./vitest-setup.ts'],
  },
})
