 <!-- ======= TALLERES Section ======= -->
 <section  class="portfolio">
      <div class="container">

        <div class="section-title">
          <h2>Memorias de talleres</h2>
        </div>

        <div class="row portfolio-container" >
            
              @foreach($tesis_main as $tesis)
          <div class="col-lg-4 col-md-2 portfolio-item filter-app">
            <div class="portfolio-wrap">
              <img src="{{$tesis['thumb']}}" class="img-fluid" alt="">
              <div class="portfolio-info">
                <h4>{{$tesis['title']}}</h4>
                <p>{{$tesis['description']}}</p>
              </div>
              <div class="portfolio-links">
                <a href="{{$tesis['url']}}" target="_blank" title="{{$tesis['title']}}"><i class="bx bx-link"></i></a>
                
              </div>
              <h4>{{$tesis['title']}}</h4>
                <p>{{$tesis['description']}}</p>
            </div>
          </div>
        @endforeach 
        </div>

      </div>
    </section>
<!-- End TALLERES Section -->

 <!-- ======= GALERIA Section ======= -->
 <section  class="portfolio">
      <div class="container">

        <div class="section-title">
          <h2>Fotos de los talleres</h2>
        </div>

        <div class="row portfolio-container">
            
              @foreach($galeria_main as $tesis)
          <div class="col-lg-4 col-md-2 portfolio-item filter-app">
            <div class="portfolio-wrap">
              <img src="{{$tesis['thumb']}}" class="img-fluid" alt="">
              <div class="portfolio-info">
                <h4>{{$tesis['title']}}</h4>
                <p>{{$tesis['description']}}</p>
              </div>
              <div class="portfolio-links">
                <a href="{{$tesis['url']}}" target="_blank" title="{{$tesis['title']}}"><i class="bx bx-link"></i></a>
                
              </div>
              <h4>{{$tesis['title']}}</h4>
                <p>{{$tesis['description']}}</p>
            </div>
          </div>
        @endforeach 
        </div>

      </div>
    </section>
<!-- End GALERIA Section -->