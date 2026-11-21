/* À COLLER DANS L'APPLICATION (app.memoaacademia.com), pas dans le site vitrine.
   Compte chaque app ouverte depuis l'écran d'accueil, sur Android ET iPhone/iPad.
   Colle-le une seule fois, dans <script>…</script> juste avant </body> de la page d'entrée de l'app. */
(function(){
var SB_URL='https://srmlgdaxddleufgtqzch.supabase.co',SB_KEY='sb_publishable_tFFsX77ia8ikCjN4NK4WFA_NOvtVfwe';
var standalone=matchMedia('(display-mode: standalone)').matches||navigator.standalone===true;
if(!standalone)return;
var ua=navigator.userAgent;
var platform=/iPhone|iPad|iPod/.test(ua)||(/Macintosh/.test(ua)&&navigator.maxTouchPoints>1)?'ios':/Android/.test(ua)?'android':'autre';
var id=null,first=false,today=new Date().toISOString().slice(0,10);
try{
  id=localStorage.getItem('memoa_install_id');
  if(!id){id=crypto.randomUUID?crypto.randomUUID():String(Date.now())+Math.random().toString(16).slice(2);localStorage.setItem('memoa_install_id',id);first=true}
  if(!first&&localStorage.getItem('memoa_install_day')===today)return; /* une ouverture comptée par jour */
  localStorage.setItem('memoa_install_day',today);
}catch(e){return}
try{fetch(SB_URL+'/rest/v1/site_events',{method:'POST',keepalive:true,
  headers:{'Content-Type':'application/json',apikey:SB_KEY,Prefer:'return=minimal'},
  body:JSON.stringify({name:'app_standalone',props:{platform:platform,first:first},page:location.pathname.slice(0,200),referrer:null,visitor:id,device:'mobile'})}).catch(function(){})}catch(e){}
})();
