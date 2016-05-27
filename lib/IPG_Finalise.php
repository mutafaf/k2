<?php
    $cert = "lib/ubl_merchant.pem";
    $pass = "Comtrust";

    $opts = array();

    $options = array(
      'trace' => 1,
      'keep_alive' => true,
      'exceptions' => 0,
      //'soap_version' => SOAP_1_1,
      'local_cert' => $cert,
      'passphrase' => $pass,
      'stream_context' => stream_context_create($opts),
      'cache_wsdl' => WSDL_CACHE_NONE

    );

    $customer = $argv[1];
    $transaction_id = $argv[2];

    $client = new SoapClient("https://demo-ipg.comtrust.ae:2443/MerchantAPI.svc?singleWsdl", $options);

    $params = array(
        'Finalize' => '',
        'request' => array(
        'Customer' => $customer,
        'Language' => 'en',
        'version' => 2,
        'TransactionID' => $transaction_id
        )
    );

    $result = $client->Finalize($params);
    $encoded = json_encode($result);
    echo $encoded;
?>
