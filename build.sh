cd service
sudo rm -rf node_modules
pnpm install
cd ..
sudo rm -rf node_modules
pnpm bootstrap
pnpm build
pm2 restart all
