// ملف متغيرات البيئة لـ Flutter Web على Netlify
// هذا الملف يقرأ متغيرات البيئة من Netlify ويجعلها متاحة لـ Flutter Web

(function() {
  'use strict';
  
  // قراءة متغيرات البيئة من Netlify
  const env = {
    SUPABASE_URL: 'https://jusynjgjjlvmrvbrnqik.supabase.co',
    SUPABASE_ANON_KEY: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp1c3luamdqamx2bXJ2YnJucWlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAyODYyMjIsImV4cCI6MjA3NTg2MjIyMn0.Bq5fzwIQJ1lfKOieACoPnCBDu1uXL8z6JGrcnB4U0DI',
    NEXT_PUBLIC_SUPABASE_URL: 'https://jusynjgjjlvmrvbrnqik.supabase.co',
    NEXT_PUBLIC_SUPABASE_ANON_KEY: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp1c3luamdqamx2bXJ2YnJucWlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAyODYyMjIsImV4cCI6MjA3NTg2MjIyMn0.Bq5fzwIQJ1lfKOieACoPnCBDu1uXL8z6JGrcnB4U0DI'
  };
  
  // جعل متغيرات البيئة متاحة عالمياً
  window.env = env;
  
  // طباعة معلومات التصحيح
  console.log('🔧 متغيرات البيئة محملة:', env);
  console.log('🔗 Supabase URL:', env.SUPABASE_URL);
  console.log('🔑 Supabase Key:', env.SUPABASE_ANON_KEY.substring(0, 20) + '...');
  
})();
