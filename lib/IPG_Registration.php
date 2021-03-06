<?php
    $cert = "lib/ubl_merchant.pem";
    $pass = "Comtrust";

    $opts = array();
    $options = array(
      'trace' => 1,
      'keep_alive' => true,
      'exceptions' => 0,
      'local_cert' => $cert,
      'passphrase' => $pass,
      'stream_context' => stream_context_create($opts),
      'cache_wsdl' => WSDL_CACHE_NONE
    );

    $client = new SoapClient("https://demo-ipg.comtrust.ae:2443/MerchantAPI.svc?singleWsdl", $options);

    $params = array(
        'Register' => '',
        'request' => array(
        'Customer' => $argv[1],
        'Language' => 'en',
        'version' => 2,
        'Amount' => $argv[2],
        'Currency' => 'PKR',
        'OrderID' => $argv[3],
        'OrderInfo' => $argv[4],
        'OrderName' => $argv[5],
        'ReturnPath' => $argv[6],
        'TransactionHint' => 'CPT:Y;VCC:Y'
        )
    );
    $result = $client->Register($params);
    echo ($result->RegisterResult->TransactionID);
?>
