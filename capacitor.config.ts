import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'app.lovable.01f7ed956bd94fc6bff46c789cc30ad7',
  appName: 'ashaway-buddy',
  webDir: 'dist',
  server: {
    url: 'https://01f7ed95-6bd9-4fc6-bff4-6c789cc30ad7.lovableproject.com?forceHideBadge=true',
    cleartext: true
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 2000,
      backgroundColor: '#1a1a1a',
      showSpinner: false
    },
    StatusBar: {
      style: 'dark'
    }
  }
};

export default config;