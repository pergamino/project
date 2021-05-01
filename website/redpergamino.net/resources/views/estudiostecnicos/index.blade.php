

 <!-- ======= TALLERES Section ======= -->
 <section  class="portfolio">
      <div class="container">

        <div class="section-title" style="margin-top: 100px;">
          <h2>Estudios Técnicos</h2>
        </div>

        <div class="row" >
          @foreach($estudios as $tesis)
          <div class="checkboxes">
            <div class="doc-frame">
              <input type="checkbox" name="rGroup" value="1" id="r{{$tesis['title']}}" checked="checked"/>
              <label class="checkbox-skin" for="r{{$tesis['title']}}">
                <a href="{{$tesis['url']}}" target="_blank">
                <div class="doc-preview" style="background-image: url('{{$tesis['thumb']}} '); background-size: contain;background-position: center center;">

                </div>
                </a>
              <label class="doc-name"><i class="material-icons">subject</i>{{\Illuminate\Support\Str::limit($tesis['title'],25, $end='...')}}</label>
              </label>
            </div>
          </div>
          @endforeach
        </div>
      </div>
    </section>
<!-- End TALLERES Section -->

<script async src="https://www.googletagmanager.com/gtag/js?id=G-THJ0900S2G"></script>
<script src="{{ URL::asset('js/gtag.js') }}" ></script>
