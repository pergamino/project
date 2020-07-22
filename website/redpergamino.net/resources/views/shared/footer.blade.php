<!-- ======= Footer ======= -->
<footer id="footer">
    <div class="footer-top">
      <div class="container">
        <div class="row">
          <div class="col-lg-2 col-md-6 footer-links">
            <ul>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Sobre Pergamino</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Sobre PROCAGICA</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Organizaciones</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Contacto técnico</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Contacto Administrativo</a></li>
            </ul>
          </div>

          <div class="col-lg-2 col-md-6 footer-links">
            <ul>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Herramientas Disponibles</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Módulo Socio-económico</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">IPSIM</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Mapa de Incidencia Regional</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Módulo Agroclimático</a></li>
            </ul>
          </div>

          <div class="col-lg-3 col-md-6 footer-links">
            <h4></h4>
            <ul>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Módulo Socio-económico</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">IPSIM</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Mapa de Incidencia Regional</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Módulo Agroclimático</a></li>
            </ul>
          </div>

          <div class="col-lg-4 col-md-4 footer-newsletter" style="color:#ffffff;">
            <h3>Contáctenos</h3>
            <form action="forms/contact.php" method="post" role="form" class="php-email-form">
                <div class="form-group">
                  <label for="name">Correo</label>
                  <input type="email" class="form-control" name="email" id="email" data-rule="email" data-msg="Please enter a valid email" />
                  <div class="validate"></div>
                </div>
              <div class="form-group">
                <label for="name">Asunto</label>
                <input type="text" class="form-control" name="subject" id="subject" data-rule="minlen:4" data-msg="Please enter at least 8 chars of subject" />
                <div class="validate"></div>
              </div>
              <div class="form-group">
                <label for="name">Mensajes</label>
                <textarea class="form-control" name="message" rows="5" data-rule="required" data-msg="Please write something for us"></textarea>
                <div class="validate"></div>
              </div>
              
              <div class="text-center"><button type="submit">Enviar</button></div>
            </form>
          </div>

        </div>
        
      </div>
    </div>
    <div class ="footer-white">
    <div class="container">
        
    <h2>Contactos</h2><br>
    <div class="row">

          <div class="col-lg-8 col-md-6 footer-links">
            <ul>
              <li>Jacques Avelino, especialista en roya:</li>
              <li>Grégoire Leclerc, procesos interinstitucionales y modelación socio-económica:</li>
              <li>Natacha Motisi, modelación biofísica:</li>
              <li>Pierre Bommel, modelación socio-ecológica:</li>
              <li>Edwin Treminio, optimización del monitoreo: </li>
            </ul>
          </div>

          <div class="col-lg-2 col-md-6 footer-links">
            <ul>
              <li><a href="#">jacques.avelino@cirad.fr</a></li>
              <li><a href="#">gregoire.leclerc@cirad.fr</a></li>
              <li><a href="#">natacha.motisi@cirad.fr</a></li>
              <li><a href="#">pierre.bommel@cirad.fr</a></li>
              <li><a href="#">Edwin.Treminio@catie.ac.cr</a></li>
            </ul>
          </div>
        
      </div>
      <img src="{{URL::asset('img/header-image.png')}}" style="max-width: 50%;left:0px;" alt="">
      <img src="{{URL::asset('img/gpl.png')}}" style="max-width:8%; float: right; margin-right:50px; margin-top:10px;" alt=""></div>
  </footer><!-- End Footer -->

  <a href="#" class="back-to-top"><i class="bx bxs-up-arrow-alt"></i></a>

  <!-- Vendor JS Files -->
  <script src="{{URL::asset('vendor/jquery/jquery.min.js')}}"></script>
  <script src="{{URL::asset('vendor/bootstrap/js/bootstrap.bundle.min.js')}}"></script>
  <script src="{{URL::asset('vendor/jquery.easing/jquery.easing.min.js')}}"></script>
  <script src="{{URL::asset('vendor/php-email-form/validate.js')}}"></script>
  <script src="{{URL::asset('vendor/isotope-layout/isotope.pkgd.min.js')}}"></script>
  <script src="{{URL::asset('vendor/venobox/venobox.min.js')}}"></script>
  <script src="{{URL::asset('vendor/owl.carousel/owl.carousel.min.js')}}"></script>
  <script src="{{URL::asset('vendor/aos/aos.js')}}"></script>

  <!-- Template Main JS File -->
  <script src="{{URL::asset('js/main.js')}}"></script>

</body>

</html>