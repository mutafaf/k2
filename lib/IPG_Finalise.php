<?php
    $cert = "Demo Merchant - New.pem";
    $pass = "Comtrust";

    $opts = array();

    $options = array(
      'trace' => 1,
      'keep_alive' => true,
      'exceptions' => 0,
      //'soap_version' => SOAP_1_1,
      'local_cert' => dirname(__FILE__) . '/'.$cert,
      'passphrase' => $pass,
      'stream_context' => stream_context_create($opts),
      'cache_wsdl' => WSDL_CACHE_NONE

    );

    $client = new SoapClient("https://demo-ipg.comtrust.ae:2443/MerchantAPI.svc?singleWsdl", $options);


    $params = array(
        'Finalize' => '',
        'request' => array(
        'Customer' => 'Demo Merchant',
        'Language' => 'en',
        'version' => 2,
        'TransactionID' => '157234167078'
        )
    );

    $result = $client->Finalize($params);
    echo "<pre>";
    print_r($result);
    echo "</pre>";
?>
