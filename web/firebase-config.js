// Firebase Configuration for dndn-86c02
const firebaseConfig = {
  apiKey: "AIzaSyARZMki7TeMsoHSDiJUTdt2bUGmxVYEtP4",
  authDomain: "dndn-86c02.firebaseapp.com",
  projectId: "dndn-86c02",
  storageBucket: "dndn-86c02.firebasestorage.app",
  messagingSenderId: "532869168095",
  appId: "1:532869168095:web:3af71d7ff6e1d81aba226a",
  measurementId: "G-YGMT61SG32"
};

// Initialize Firebase
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';
import { getStorage } from 'firebase/storage';
import { getMessaging } from 'firebase/messaging';

const app = initializeApp(firebaseConfig);

export const auth = getAuth(app);
export const db = getFirestore(app);
export const storage = getStorage(app);
export const messaging = getMessaging(app);
export default app;
