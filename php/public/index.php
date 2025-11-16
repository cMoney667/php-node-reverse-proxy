<?php
header('Content-Type: application/json');
echo json_encode([
  'from' => 'php',
  'uri' => $_SERVER['REQUEST_URI'] ?? '/',
  'note' => 'You hit the PHP fallback because Node returned 404.'
]);
