import { defineConfig, createLogger } from 'vite'
import elm from 'vite-plugin-elm'

const logger = createLogger()
const { warn } = logger

logger.warn = (msg, options) => {
  if (msg.includes('vite-plugin-elm')) return
  warn(msg, options)
}

export default defineConfig({
  resolve: {
    extensions: ['.js', '.ts', '.elm', '.json'],
  },
  plugins: [elm()],
  customLogger: logger,
})
