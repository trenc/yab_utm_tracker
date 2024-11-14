<?php

declare(strict_types=1);

class UtmTracker
{
    private $event = 'yab_utm_tracker';

    private $utmParams = [
        'utm_source',
        'utm_medium',
        'utm_campaign',
        'utm_term',
        'utm_content',
    ];

    public function __construct()
    {
        \Txp::get('\Textpattern\Tag\Registry')
            ->register([$this, 'utmTracker'], $this->event);
    }

    public function utmTracker(array $atts): ?string
    {
        $this->startSession();
        $this->storeUtmParameters();

        extract(lAtts([
            'tracker' => null,
            'clear' => 0,
        ], $atts));

        if ($clear) {
            $_SESSION[$this->event] = [];
            return null;
        }

        if (!$tracker) {
            return null;
        }

        return $_SESSION[$this->event][$tracker] ?? '';
    }

    private function startSession(): void
    {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
    }

    private function storeUtmParameters(): void
    {
        foreach ($this->utmParams as $param) {
            $_SESSION[$this->event][$param] = $_SESSION[$this->event][$param] ?? (filter_input(
                INPUT_GET,
                $param,
                FILTER_SANITIZE_FULL_SPECIAL_CHARS,
            ) ?: null);
        }
    }
}
