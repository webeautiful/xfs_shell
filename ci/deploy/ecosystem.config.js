module.exports = {
  apps: [
    {
      name: 'namexxx',
      port: '3001',
      exec_mode: 'cluster',
      instances: 'max',
      script: './dist/server/index.mjs',
      env: {
        'NUXT_APP_BASE_URL': '/'
      }
    }
  ]
}
