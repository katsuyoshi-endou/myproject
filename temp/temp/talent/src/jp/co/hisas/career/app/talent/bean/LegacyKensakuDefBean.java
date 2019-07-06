package jp.co.hisas.career.app.talent.bean;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;

import jp.co.hisas.career.app.talent.dto.KensakuCategoryDto;
import jp.co.hisas.career.app.talent.dto.KensakuKigoDto;
import jp.co.hisas.career.app.talent.dto.KensakuKomokuDto;
import jp.co.hisas.career.util.dto.CodeMasterDto;
import jp.co.hisas.career.util.dto.PersonZokuseiTeigiDto;

public class LegacyKensakuDefBean implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private ArrayList<KensakuCategoryDto> kensakuCategoryDtoList;
	private HashMap<String, ArrayList<KensakuKomokuDto>> kensakuKomokuDtoListMap;
	private HashMap<String, ArrayList<KensakuKigoDto>> kensakuKigoDtoListMap;
	private HashMap<String, ArrayList<CodeMasterDto>> codeMasterDtoListMap;
	private HashMap<String, PersonZokuseiTeigiDto> personZokuseiTeigiDtoMap;
	
	public boolean canRetireSrch;
	
	public LegacyKensakuDefBean() {
		this.kensakuCategoryDtoList = new ArrayList<KensakuCategoryDto>();
		this.kensakuKomokuDtoListMap = new HashMap<String, ArrayList<KensakuKomokuDto>>();
		this.kensakuKigoDtoListMap = new HashMap<String, ArrayList<KensakuKigoDto>>();
		this.codeMasterDtoListMap = new HashMap<String, ArrayList<CodeMasterDto>>();
		this.personZokuseiTeigiDtoMap = new HashMap<String, PersonZokuseiTeigiDto>();
	}
	
	public void addKensakuCategoryDtoList( final KensakuCategoryDto dto ) {
		this.kensakuCategoryDtoList.add( dto );
	}
	
	public void putKomokuByCategoryMap( final String key, final KensakuKomokuDto dto ) {
		if (!this.kensakuKomokuDtoListMap.containsKey( key )) {
			this.kensakuKomokuDtoListMap.put( key, new ArrayList<KensakuKomokuDto>() );
		}
		ArrayList<KensakuKomokuDto> tmpList = this.kensakuKomokuDtoListMap.get( key );
		tmpList.add( dto );
		this.kensakuKomokuDtoListMap.put( key, tmpList );
	}
	
	public void putKensakuKigoDtoListMap( final String key, final KensakuKigoDto dto ) {
		if (!this.kensakuKigoDtoListMap.containsKey( key )) {
			this.kensakuKigoDtoListMap.put( key, new ArrayList<KensakuKigoDto>() );
		}
		ArrayList<KensakuKigoDto> tmpList = this.kensakuKigoDtoListMap.get( key );
		tmpList.add( dto );
		this.kensakuKigoDtoListMap.put( key, tmpList );
	}
	
	public void putCodeMasterDtoListMap( final String key, final CodeMasterDto dto ) {
		if (!this.codeMasterDtoListMap.containsKey( key )) {
			this.codeMasterDtoListMap.put( key, new ArrayList<CodeMasterDto>() );
		}
		ArrayList<CodeMasterDto> tmpList = this.codeMasterDtoListMap.get( key );
		tmpList.add( dto );
		this.codeMasterDtoListMap.put( key, tmpList );
	}
	
	public void putPersonZokuseiTeigiDtoMap( final String key, final PersonZokuseiTeigiDto dto ) {
		this.personZokuseiTeigiDtoMap.put( key, dto );
	}
	
	public HashMap<String, PersonZokuseiTeigiDto> getPersonZokuseiTeigiDtoMap() {
		return personZokuseiTeigiDtoMap;
	}
	
	public ArrayList<KensakuCategoryDto> getKensakuCategoryDtoList() {
		return kensakuCategoryDtoList;
	}
	
	public HashMap<String, ArrayList<CodeMasterDto>> getCodeMasterDtoListMap() {
		return codeMasterDtoListMap;
	}
	
	public HashMap<String, ArrayList<KensakuKigoDto>> getKensakuKigoDtoListMap() {
		return kensakuKigoDtoListMap;
	}
	
	public HashMap<String, ArrayList<KensakuKomokuDto>> getKensakuKomokuDtoListMap() {
		return kensakuKomokuDtoListMap;
	}
	
	public ArrayList<CodeMasterDto> getCodeMasterDtoList( final String key ) {
		if (this.codeMasterDtoListMap.get( key ) == null) {
			return new ArrayList<CodeMasterDto>();
		}
		return this.codeMasterDtoListMap.get( key );
	}
	
	public ArrayList<KensakuKigoDto> getKensakuKigoDtoList( final String key ) {
		if (this.kensakuKigoDtoListMap.get( key ) == null) {
			if (this.kensakuKigoDtoListMap.get( "default" ) != null) {
				return this.kensakuKigoDtoListMap.get( "default" );
			}
			return new ArrayList<KensakuKigoDto>();
		}
		return this.kensakuKigoDtoListMap.get( key );
	}
	
	public ArrayList<KensakuKomokuDto> getKensakuKomokuDtoList( final String key ) {
		if (this.kensakuKomokuDtoListMap.get( key ) == null) {
			return new ArrayList<KensakuKomokuDto>();
		}
		return this.kensakuKomokuDtoListMap.get( key );
	}
	
	public PersonZokuseiTeigiDto getPersonZokuseiTeigiDtoMap( final String key ) {
		if (this.personZokuseiTeigiDtoMap.get( key ) == null) {
			return new PersonZokuseiTeigiDto();
		}
		return this.personZokuseiTeigiDtoMap.get( key );
	}
	
}
