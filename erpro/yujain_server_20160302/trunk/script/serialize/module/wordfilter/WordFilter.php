<?php

class WordFilter extends SerializeBase {
		
	const SRC_WORD_FILTER_DATA_FILE = "/wordfilter/wordfilter.xml";
	//文件定义
// 	const WORD_FILTER_DATA_OUTPUT_FILE = "/output/wordfilter.txt";
	const WORD_FILTER_DATA_OUTPUT_FILE = "/../../front-end/wordfilter.txt";
	
	public function __construct() {
		$data = $this->buildWordFilter();
		$this->writeToFile ( $data, ROOT . self::WORD_FILTER_DATA_OUTPUT_FILE );
		echo ('导出敏感词【前端】数据成功，path='. self::WORD_FILTER_DATA_OUTPUT_FILE . "\n");
	}
	
	
	/**
	 * wordfilter
	 * npc基础信息
	 * @param String $inFile
	 */
	public function buildWordFilter() {
		$doc = new DOMDocument();
		$doc->load(DATA_PATH . self::SRC_WORD_FILTER_DATA_FILE);
		$mgcs = $doc->getElementsByTagName( "mgc" );
		$asArray = array();
		foreach($mgcs as $mgc )
		{
			$content = $mgc->nodeValue;
			$asArray[] = $content;
		}
		return $this->getArrayAMF ( $asArray );
	}
}
?>