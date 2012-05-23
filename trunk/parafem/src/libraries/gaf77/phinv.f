c  *************************************************************************
c  *                                                                       *
c  *                           Function phinv                              *
c  *                                                                       *
c  *************************************************************************
c  Single Precision Version 1.1
c  Written by Gordon A. Fenton, TUNS, 1990
c  Latest Update: May 18, 1997
c
c  PURPOSE  to return the inverse of the standard normal cumulative
c           distribution function
c
c  For a given probability q lying between 0 and 1, this function returns
c  the corresponding standard normal variate value, ie z such that
c
c      q = P[ Z <= z ]
c
c  The value z is obtained through inverse interpolation of the tabulated
c  probability values (see U.S. Dept. of Commerce, Handbook of Mathematical
c  Functions, pg 954).
c  Notes:
c       - the following is based on NPROBS = 768, so if this is changed, this
c         routine will require some major modifications.
c       - due to catastrophic cancellation, this routine is much more accurate
c         for q values close to 0 than for q values close to 1.
c
c  REVISION HISTORY:
c  1.1	brought contents of gblck.f directly into this routine, some compilers
c	don't like externally defined common blocks. (May 18/97)
c----------------------------------------------------------------------------
      real function phinv(q)
      parameter (NPROBS = 768)
      dimension p(NPROBS)
c						powers of two
      integer itwo(8)
      data itwo/128,64,32,16,8,4,2,1/
c						(empirical) fudge factors
      data f1,               f2,               f3/
     >     0.245575499584, 0.297337076337, -0.003148948457/
c						some constants
      data pt01,   sixth,                   half,  one,  two/
     >     0.01, 0.1666666666666666667, 0.5, 1., 2./
      data rt2pi/2.5066282746310005024/, big/30./, zero/0.0/
      data a1/2.30753/, a2/0.27061/, b1/0.99229/, b2/0.04481/
c						probability tables
      data (p(i),i=1,15)/
     >4.960106436853684e-01,4.920216862830980e-01,4.880335265858873e-01,
     >4.840465631471693e-01,4.800611941616275e-01,4.760778173458932e-01,
     >4.720968298194789e-01,4.681186279860126e-01,4.641436074148279e-01,
     >4.601721627229710e-01,4.562046874576832e-01,4.522415739794162e-01,
     >4.482832133454389e-01,4.443299951940936e-01,4.403823076297575e-01/
      data (p(i),i=16,30)/
     >4.364405371085672e-01,4.325050683249616e-01,4.285762840990993e-01,
     >4.246545652652046e-01,4.207402905608970e-01,4.168338365175577e-01,
     >4.129355773517854e-01,4.090458848579941e-01,4.051651283022042e-01,
     >4.012936743170763e-01,3.974318867982395e-01,3.935801268019605e-01,
     >3.897387524442028e-01,3.859081188011227e-01,3.820885778110474e-01/
      data (p(i),i=31,45)/
     >3.782804781779807e-01,3.744841652766800e-01,3.706999810593465e-01,
     >3.669282639639719e-01,3.631693488243809e-01,3.594235667820088e-01,
     >3.556912451994533e-01,3.519727075758372e-01,3.482682734640177e-01,
     >3.445782583896759e-01,3.409029737723226e-01,3.372427268482495e-01,
     >3.335978205954577e-01,3.299685536605936e-01,3.263552202879201e-01/
      data (p(i),i=46,60)/
     >3.227581102503477e-01,3.191775087825558e-01,3.156136965162226e-01,
     >3.120669494173905e-01,3.085375387259869e-01,3.050257308975195e-01,
     >3.015317875469662e-01,2.980559653948764e-01,2.945985162156980e-01,
     >2.911596867883464e-01,2.877397188490270e-01,2.843388490463242e-01,
     >2.809573088985644e-01,2.775953247534649e-01,2.742531177500736e-01/
      data (p(i),i=61,75)/
     >2.709309037830058e-01,2.676288934689831e-01,2.643472921156776e-01,
     >2.610862996928617e-01,2.578461108058648e-01,2.546269146713361e-01,
     >2.514288950953101e-01,2.482522304535706e-01,2.450970936743094e-01,
     >2.419636522230730e-01,2.388520680899867e-01,2.357624977792512e-01,
     >2.326950923008975e-01,2.296499971647906e-01,2.266273523768682e-01/
      data (p(i),i=76,90)/
     >2.236272924375995e-01,2.206499463426497e-01,2.176954375857332e-01,
     >2.147638841636371e-01,2.118553985833966e-01,2.089700878716017e-01,
     >2.061080535858131e-01,2.032693918280685e-01,2.004541932604497e-01,
     >1.976625431226924e-01,1.948945212518084e-01,1.921502021036962e-01,
     >1.894296547767121e-01,1.867329430371727e-01,1.840601253467595e-01/
      data (p(i),i=91,105)/
     >1.814112548917973e-01,1.787863796143717e-01,1.761855422452580e-01,
     >1.736087803386246e-01,1.710561263084818e-01,1.685276074668378e-01,
     >1.660232460635296e-01,1.635430593276923e-01,1.610870595108309e-01,
     >1.586552539314571e-01,1.562476450212546e-01,1.538642303727349e-01,
     >1.515050027883437e-01,1.491699503309815e-01,1.468590563758959e-01/
      data (p(i),i=106,120)/
     >1.445722996639096e-01,1.423096543559392e-01,1.400710900887691e-01,
     >1.378565720320355e-01,1.356660609463827e-01,1.334995132427472e-01,
     >1.313568810427307e-01,1.292381122400178e-01,1.271431505627982e-01,
     >1.250719356371502e-01,1.230244030513434e-01,1.210004844210182e-01,
     >1.190001074552007e-01,1.170231960231087e-01,1.150696702217083e-01/
      data (p(i),i=121,135)/
     >1.131394464439773e-01,1.112324374478346e-01,1.093485524256919e-01,
     >1.074876970745869e-01,1.056497736668553e-01,1.038346811213005e-01,
     >1.020423150748192e-01,1.002725679544421e-01,9.852532904974787e-02,
     >9.680048458561030e-02,9.509791779523907e-02,9.341750899347179e-02,
     >9.175913565028082e-02,9.012267246445249e-02,8.850799143740207e-02/
      data (p(i),i=136,150)/
     >8.691496194708503e-02,8.534345082196698e-02,8.379332241501425e-02,
     >8.226443867766897e-02,8.075665923377101e-02,7.926984145339244e-02,
     >7.780384052654643e-02,7.635850953673912e-02,7.493369953432705e-02,
     >7.352925960964835e-02,7.214503696589381e-02,7.078087699168556e-02,
     >6.943662333333178e-02,6.811211796672545e-02,6.680720126885809e-02/
      data (p(i),i=151,165)/
     >6.552171208891650e-02,6.425548781893586e-02,6.300836446397839e-02,
     >6.178017671181191e-02,6.057075800205902e-02,5.937994059479307e-02,
     >5.820755563855307e-02,5.705343323775425e-02,5.591740251946942e-02,
     >5.479929169955799e-02,5.369892814811972e-02,5.261613845425206e-02,
     >5.155074849008934e-02,5.050258347410369e-02,4.947146803364810e-02/
      data (p(i),i=166,180)/
     >4.845722626672283e-02,4.745968180294735e-02,4.647865786372007e-02,
     >4.551397732154983e-02,4.456546275854306e-02,4.363293652403194e-02,
     >4.271622079132897e-02,4.181513761359495e-02,4.092950897880737e-02,
     >4.005915686381706e-02,3.920390328748263e-02,3.836357036287125e-02,
     >3.753798034851680e-02,3.672695569872630e-02,3.593031911292582e-02/
      data (p(i),i=181,195)/
     >3.514789358403880e-02,3.437950244589000e-02,3.362496941962834e-02,
     >3.288411865916385e-02,3.215677479561369e-02,3.144276298075271e-02,
     >3.074190892946599e-02,3.005403896119979e-02,2.937898004040940e-02,
     >2.871655981600180e-02,2.806660665977251e-02,2.742894970383680e-02,
     >2.680341887705495e-02,2.618984494045268e-02,2.558805952163862e-02/
      data (p(i),i=196,210)/
     >2.499789514822043e-02,2.441918528022258e-02,2.385176434150854e-02,
     >2.329546775021185e-02,2.275013194817921e-02,2.221559442943144e-02,
     >2.169169376764679e-02,2.117826964267228e-02,2.067516286607007e-02,
     >2.018221540570442e-02,1.969927040937691e-02,1.922617222751732e-02,
     >1.876276643493774e-02,1.830889985165896e-02,1.786442056281656e-02/
      data (p(i),i=211,225)/
     >1.742917793765708e-02,1.700302264763282e-02,1.658580668360504e-02,
     >1.617738337216612e-02,1.577760739109052e-02,1.538633478392548e-02,
     >1.500342297373219e-02,1.462873077598925e-02,1.426211841066888e-02,
     >1.390344751349859e-02,1.355258114642000e-02,1.320938380725628e-02,
     >1.287372143860205e-02,1.254546143594659e-02,1.222447265504473e-02/
      data (p(i),i=226,240)/
     >1.191062541854704e-02,1.160379152190355e-02,1.130384423855280e-02,
     >1.101065832441139e-02,1.072411002167578e-02,1.044407706195111e-02,
     >1.017043866871969e-02,9.903075559164254e-03,9.641869945358317e-03,
     >9.386705534838558e-03,9.137467530572652e-03,8.894042630336774e-03,
     >8.656319025516557e-03,8.424186399345668e-03,8.197535924596155e-03/
      data (p(i),i=241,255)/
     >7.976260260733725e-03,7.760253550553653e-03,7.549411416309215e-03,
     >7.343630955348346e-03,7.142810735271399e-03,6.946850788624337e-03,
     >6.755652607140672e-03,6.569119135546753e-03,6.387154764943170e-03,
     >6.209665325776159e-03,6.036558080412646e-03,5.867741715332553e-03,
     >5.703126332950670e-03,5.542623443082595e-03,5.386145954066668e-03/
      data (p(i),i=256,270)/
     >5.233608163555781e-03,5.084925748991054e-03,4.940015757770644e-03,
     >4.798796597126176e-03,4.661188023718732e-03,4.527111132967332e-03,
     >4.396488348121286e-03,4.269243409089352e-03,4.145301361036025e-03,
     >4.024588542758334e-03,3.907032574852809e-03,3.792562347685491e-03,
     >3.681108009174983e-03,3.572600952399752e-03,3.466973803040674e-03/
      data (p(i),i=271,285)/
     >3.364160406669203e-03,3.264095815891321e-03,3.166716277357817e-03,
     >3.071959218650500e-03,2.979763235054556e-03,2.890068076226160e-03,
     >2.802814632765049e-03,2.717944922701276e-03,2.635402077904969e-03,
     >2.555130330427924e-03,2.477074998785855e-03,2.401182474189245e-03,
     >2.327400206731556e-03,2.255676691542308e-03,2.185961454913232e-03/
      data (p(i),i=286,300)/
     >2.118205040404608e-03,2.052358994939774e-03,1.988375854894309e-03,
     >1.926209132187884e-03,1.865813300384045e-03,1.807143780806431e-03,
     >1.750156928676083e-03,1.694810019277238e-03,1.641061234157026e-03,
     >1.588869647364877e-03,1.538195211738036e-03,1.488998745237446e-03,
     >1.441241917340019e-03,1.394887235492248e-03,1.349898031630096e-03/
      data (p(i),i=301,315)/
     >1.306238448769467e-03,1.263873427672299e-03,1.222768693592260e-03,
     >1.182890743104407e-03,1.144206831022698e-03,1.106684957409247e-03,
     >1.070293854678923e-03,1.035002974802841e-03,1.000782476614011e-03,
     >9.676032132183563e-04,9.354367195140999e-04,9.042551998223409e-04,
     >8.740315156315670e-04,8.447391734586284e-04,8.163523128285638e-04/
      data (p(i),i=316,330)/
     >7.888456943755737e-04,7.621946880672361e-04,7.363752615539311e-04,
     >7.113639686453650e-04,6.871379379158485e-04,6.636748614399681e-04,
     >6.409529836600560e-04,6.189510903868352e-04,5.976484979344154e-04,
     >5.770250423907672e-04,5.570610690246212e-04,5.377374218296949e-04,
     >5.190354332069722e-04,5.009369137857219e-04,4.834241423837776e-04/
      data (p(i),i=331,345)/
     >4.664798561075492e-04,4.500872405921174e-04,4.342299203816563e-04,
     >4.188919494503698e-04,4.040578018640217e-04,3.897123625820324e-04,
     >3.758409184000837e-04,3.624291490330445e-04,3.494631183379715e-04,
     >3.369292656768813e-04,3.248143974188780e-04,3.131056785812003e-04,
     >3.017906246086373e-04,2.908570932907434e-04,2.802932768161773e-04/
      data (p(i),i=346,360)/
     >2.700876939634748e-04,2.602291824274666e-04,2.507068912805378e-04,
     >2.415102735678360e-04,2.326290790355250e-04,2.240533469910931e-04,
     >2.157733992947175e-04,2.077798334806213e-04,2.000635160073205e-04,
     >1.926155756356333e-04,1.854273969332782e-04,1.784906139048473e-04,
     >1.717971037459309e-04,1.653389807201100e-04,1.591085901575340e-04/
      data (p(i),i=361,375)/
     >1.530985025737555e-04,1.473015079074726e-04,1.417106098758194e-04,
     >1.363190204458020e-04,1.311201544204847e-04,1.261076241384867e-04,
     >1.212752342853580e-04,1.166169768153681e-04,1.121270259822471e-04,
     >1.077997334773883e-04,1.036296236740311e-04,9.961138897591672e-05,
     >9.573988526891469e-05,9.201012747410561e-05,8.841728520080404e-05/
      data (p(i),i=376,390)/
     >8.495667849799789e-05,8.162377370268624e-05,7.841417938358505e-05,
     >7.532364237868341e-05,7.234804392511995e-05,6.948339587986524e-05,
     >6.672583702968470e-05,6.407162948887459e-05,6.151715518325534e-05,
     >5.905891241892255e-05,5.669351253425669e-05,5.441767663369976e-05,
     >5.222823240182019e-05,5.012211099618837e-05,4.809634401760274e-05/
      data (p(i),i=391,405)/
     >4.614806055620888e-05,4.427448431207072e-05,4.247293078876124e-05,
     >4.074080455855082e-05,3.907559659778755e-05,3.747488169107352e-05,
     >3.593631590285383e-05,3.445763411505314e-05,3.303664762940245e-05,
     >3.167124183311996e-05,3.035937392661827e-05,2.909907071193095e-05,
     >2.788842644056393e-05,2.672560071949210e-05,2.560881647404153e-05/
      data (p(i),i=406,420)/
     >2.453635796640967e-05,2.350656886859557e-05,2.251785038852544e-05,
     >2.156865944818060e-05,2.065750691254679e-05,1.978295586822407e-05,
     >1.894361995055329e-05,1.813816171813091e-05,1.736529107360408e-05,
     >1.662376372965224e-05,1.591237971908220e-05,1.522998194797792e-05,
     >1.457545479086707e-05,1.394772272688124e-05,1.334574901590634e-05/
      data (p(i),i=421,435)/
     >1.276853441373497e-05,1.221511592525306e-05,1.168456559470741e-05,
     >1.117598933212056e-05,1.068852577493443e-05,1.022134518398408e-05,
     >9.773648372917573e-06,9.344665670196364e-06,8.933655912827005e-06,
     >8.539905470991814e-06,8.162727302763068e-06,7.801460038101355e-06,
     >7.455467091355145e-06,7.124135801495341e-06,6.806876599334045e-06/
      data (p(i),i=436,450)/
     >6.503122200992801e-06,6.212326826901514e-06,5.933965445624679e-06,
     >5.667533041826751e-06,5.412543907703856e-06,5.168530957224142e-06,
     >4.935045062533278e-06,4.711654411897247e-06,4.497943888567909e-06,
     >4.293514469971870e-06,4.097982646636362e-06,3.910979860280711e-06,
     >3.732151960514484e-06,3.561158679597556e-06,3.397673124730062e-06/
      data (p(i),i=451,465)/
     >3.241381287353394e-06,3.091981568956177e-06,2.949184322891521e-06,
     >2.812711411724217e-06,2.682295779638856e-06,2.557681039451524e-06,
     >2.438621073779427e-06,2.324879649934414e-06,2.216230048117548e-06,
     >2.112454702502847e-06,2.013344854809340e-06,1.918700219970900e-06,
     >1.828328663524165e-06,1.742045890344663e-06,1.659675144371463e-06/
      data (p(i),i=466,480)/
     >1.581046918970512e-06,1.505998677596157e-06,1.434374584420136e-06,
     >1.366025244606141e-06,1.300807453917281e-06,1.238583957352471e-06,
     >1.179223216516399e-06,1.122599185436174e-06,1.068591094545936e-06,
     >1.017083242568706e-06,9.679647960327358e-07,9.211295961671412e-07,
     >8.764759729292055e-07,8.339065659229126e-07,7.933281519755972e-07/
      data (p(i),i=481,495)/
     >7.546514791463692e-07,7.177911069469003e-07,6.826652525616647e-07,
     >6.491956428613364e-07,6.173073720091949e-07,5.869287644666382e-07,
     >5.579912432097829e-07,5.304292029750950e-07,5.041798883575367e-07,
     >4.791832765903206e-07,4.553819648407320e-07,4.327210618617021e-07,
     >4.111480838439311e-07,3.906128543183266e-07,3.710674079633336e-07/
      data (p(i),i=496,510)/
     >3.524658981764252e-07,3.347645082736184e-07,3.179213661852820e-07,
     >3.018964625208491e-07,2.866515718791945e-07,2.721501772855827e-07,
     >2.583573976399725e-07,2.452399180653704e-07,2.327659230486003e-07,
     >2.209050322695440e-07,2.096282390183694e-07,1.989078511037129e-07,
     >1.887174341580604e-07,1.790317572498343e-07,1.698267407147598e-07/
      data (p(i),i=511,525)/
     >1.610794061221380e-07,1.527678282945667e-07,1.448710893025085e-07,
     >1.373692343578420e-07,1.302432295332016e-07,1.234749212365168e-07,
     >1.170469973726320e-07,1.109429501263468e-07,1.051470403035407e-07,
     >9.964426316933494e-08,9.442031572442990e-08,8.946156536290779e-08,
     >8.475501985682844e-08,8.028829861495895e-08,7.604960516488729e-08/
      data (p(i),i=526,540)/
     >7.202770080965977e-08,6.821187941186212e-08,6.459194325982505e-08,
     >6.115817997230602e-08,5.790134039964602e-08,5.481261748095645e-08,
     >5.188362601842435e-08,4.910638333128551e-08,4.647329075344129e-08,
     >4.397711594005889e-08,4.161097594981976e-08,3.936832107075916e-08,
     >3.724291935887129e-08,3.522884185984314e-08,3.332044848542857e-08/
      data (p(i),i=541,555)/
     >3.151237451708229e-08,2.979951771053636e-08,2.817702597603999e-08,
     >2.664028560996721e-08,2.518491005446115e-08,2.380672916270041e-08,
     >2.250177894826861e-08,2.126629179795917e-08,2.009668712817647e-08,
     >1.898956246588774e-08,1.794168493584716e-08,1.694998313655083e-08,
     >1.601153938809098e-08,1.512358233576103e-08,1.428347989392278e-08/
      data (p(i),i=556,570)/
     >1.348873251527842e-08,1.273696677129993e-08,1.202592923015495e-08,
     >1.135348061903221e-08,1.071759025831089e-08,1.011633075554139e-08,
     >9.547872947704290e-09,9.010481080699081e-09,8.502508215475082e-09,
     >8.022391850663509e-09,7.568649751997725e-09,7.139875979218420e-09,
     >6.734737101557546e-09,6.351968593271951e-09,5.990371401063532e-09/
      data (p(i),i=571,585)/
     >5.648808675570940e-09,5.326202659455512e-09,5.021531724924521e-09,
     >4.733827553845581e-09,4.462172453901613e-09,4.205696804522029e-09,
     >3.963576626597628e-09,3.735031270249742e-09,3.519321215174624e-09,
     >3.315745978326164e-09,3.123642123930022e-09,2.942381371044379e-09,
     >2.771368794094646e-09,2.610041112012914e-09,2.457865061808032e-09/
      data (p(i),i=586,600)/
     >2.314335852578571e-09,2.178975696160569e-09,2.051332410772609e-09,
     >1.930978094185322e-09,1.817507863099436e-09,1.710538655567010e-09,
     >1.609708093434255e-09,1.514673401922662e-09,1.425110383596567e-09,
     >1.340712444091877e-09,1.261189667101099e-09,1.186267936225734e-09,
     >1.115688101417170e-09,1.049205187833157e-09,9.865876450377014e-10/
      data (p(i),i=601,615)/
     >9.276166345691163e-10,8.720853539929702e-10,8.197983956451329e-10,
     >7.705711383542473e-10,7.242291705137658e-10,6.806077429504144e-10,
     >6.395512501096636e-10,6.009127381488439e-10,5.645534385958076e-10,
     >5.303423262948813e-10,4.981557004231254e-10,4.678767874181614e-10,
     >4.393953647146701e-10,4.126074042396769e-10,3.874147346675664e-10/
      data (p(i),i=616,630)/
     >3.637247214840693e-10,3.414499639547374e-10,3.205080081373417e-10,
     >3.008210751196840e-10,2.823158037043269e-10,2.649230067999402e-10,
     >2.485774408153008e-10,2.332175873867525e-10,2.187854468029041e-10,
     >2.052263425218952e-10,1.924887362065496e-10,1.805240527313422e-10,
     >1.692865146423052e-10,1.587329855769880e-10,1.488228221762322e-10/
      data (p(i),i=631,645)/
     >1.395177340430679e-10,1.307816513264241e-10,1.225805995286331e-10,
     >1.148825811560307e-10,1.076574638512162e-10,1.008768746639295e-10,
     >9.451410013495054e-11,8.854399188407803e-11,8.294287740902139e-11,
     >7.768847581709834e-11,7.275981822590379e-11,6.813717258273434e-11,
     >6.380197266544754e-11,5.973675103973090e-11,5.592507575942690e-11/
      data (p(i),i=646,660)/
     >5.235149060764004e-11,4.900145868690975e-11,4.586130917672491e-11,
     >4.291818708617980e-11,4.016000583859125e-11,3.757540253348849e-11,
     >3.515369573951724e-11,3.288484567954244e-11,3.075941667656468e-11,
     >2.876854173604333e-11,2.690388914682007e-11,2.515763098911859e-11,
     >2.352241344404167e-11,2.199132880464250e-11,2.055788909399524e-11/
      data (p(i),i=661,675)/
     >1.921600120077499e-11,1.795994344767311e-11,1.678434351254311e-11,
     >1.568415762649946e-11,1.465465097730285e-11,1.369137925025025e-11,
     >1.279017124247953e-11,1.194711249009093e-11,1.115852985079933e-11,
     >1.042097698796524e-11,9.731220704826869e-12,9.086228080565395e-12,
     >8.483154362502072e-12,7.919331571248458e-12,7.392257778017862e-12/
      data (p(i),i=676,690)/
     >6.899587015569721e-12,6.439119786395897e-12,6.008794133785011e-12,
     >5.606677243315662e-12,5.230957544144618e-12,4.879937281169313e-12,
     >4.552025530768030e-12,4.245731634354438e-12,3.959659025435898e-12,
     >3.692499427235594e-12,3.443027399236997e-12,3.210095212234586e-12,
     >2.992628032635060e-12,2.789619397847642e-12,2.600126965638169e-12/
      data (p(i),i=691,705)/
     >2.423268521298989e-12,2.258218227411716e-12,2.104203101851851e-12,
     >1.960499710509255e-12,1.826431061976962e-12,1.701363692195681e-12,
     >1.584704927736075e-12,1.475900317055532e-12,1.374431219685123e-12,
     >1.279812543885835e-12,1.191590623864497e-12,1.109341228159143e-12,
     >1.032667691294276e-12,9.611991612689379e-13,8.945889558769916e-13/
      data (p(i),i=706,720)/
     >8.325130212702670e-13,7.746684865636528e-13,7.207723086467529e-13,
     >6.705600017118691e-13,6.237844463331584e-13,5.802147732383270e-13,
     >5.396353172029230e-13,5.018446367696487e-13,4.666545957513176e-13,
     >4.338895027178080e-13,4.033853048947575e-13,3.749888331162318e-13,
     >3.485570946752429e-13,3.239566111061341e-13,3.010627981117446e-13/
      data (p(i),i=721,735)/
     >2.797593850166439e-13,2.599378712863654e-13,2.414970178016698e-13,
     >2.243423707173588e-13,2.083858158672078e-13,1.935451618009657e-13,
     >1.797437496562159e-13,1.669100881779288e-13,1.549775123019207e-13,
     >1.438838638157592e-13,1.335711927020462e-13,1.239854778550311e-13,
     >1.150763659422917e-13,1.067969272592302e-13,9.910342749547497e-14/
      data (p(i),i=736,750)/
     >9.195511439940067e-14,8.531401838998034e-14,7.914476622443238e-14,
     >7.341440688571708e-14,6.809224890620008e-14,6.314970839286098e-14,
     >5.856016706548484e-14,5.429883966255224e-14,5.034265011012925e-14,
     >4.667011588719071e-14,4.326124005658145e-14,4.009741046439491e-14,
     >3.716130564205506e-14,3.443680697493761e-14,3.190891672910920e-14/
      data (p(i),i=751,765)/
     >2.956368155375915e-14,2.738812110130123e-14,2.537016142999860e-14,
     >2.349857287541125e-14,2.176291209708596e-14,2.015346802575318e-14,
     >1.866121145397440e-14,1.727774802974088e-14,1.599527442805322e-14,
     >1.480653749004804e-14,1.370479613286938e-14,1.268378584624278e-14,
     >1.173768560367169e-14,1.086108702736900e-14,1.004896565652634e-14/
      data (p(i),i=766,768)/
     >9.296654178339954e-15,8.599817490408714e-15,7.954429471721532e-15/

c------------------------------ start executable statements -------------------
      if( q .lt. half ) then
         qr    = q
         zsign = -one
      else
         qr    = one - q
         zsign = one
      endif
c					find closest p(i) to qr
      if( qr .gt. p(1) ) then
         r  = half - qr
         r2 = qr - p(1)
         i  = 0
      else if( qr .lt. p(768) ) then
         if( qr .eq. zero ) then
            phinv = zsign*big
         else
            t  = sqrt( alog(one/(qr*qr)) )
            zo = t - (a1 + a2*t)/(one + b1*t + b2*t*t)
            phinv = zsign*zo
         endif
         return
      else
c					find i such that p(i) < qr < p(i+1)
         if( qr .lt. p(512) ) then
            if( qr .gt. p(513) ) then
               i = 512
               go to 20
            endif
            i  = 640
            js = 2
         else
            i  = 256
            js = 1
         endif

         do 10 j = js, 8
            if( qr .gt. p(i) ) then
               i = i - itwo(j)
            else
               i = i + itwo(j)
            endif
  10     continue
         if( qr .gt. p(i) ) i = i - 1
  20     r  = p(i) - qr
         r2 = qr - p(i+1)
      endif
c					now choose p(i) or p(i+1)
      if( r2 .lt. r ) then
         r = -r2
         i = i + 1
      endif
c					inverse interpolation
      zo  = pt01*float(i)
      zo2 = zo*zo
      zo3 = zo*zo2

      t   = r*rt2pi*exp(half*zo2)
      t2  = t*t
      t3  = t*t2
      t4  = t2*t2

      zo  = zsign*(zo + t + half*zo*t2 + (two*zo2 + one)*t3*sixth
     >         + t4*(f1*zo3+f2*zo+f3))

c					iterate once
      r   = q - phi(zo)
      zo2 = zo*zo
      zo3 = zo*zo2

      t   = r*rt2pi*exp(half*zo2)
      t2  = t*t
      t3  = t*t2
      t4  = t2*t2

      phinv  = zo + t + half*zo*t2 + (two*zo2 + one)*t3*sixth
     >                + t4*(f1*zo3+f2*zo+f3)

      return
      end
