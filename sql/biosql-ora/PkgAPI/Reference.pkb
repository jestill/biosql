--
-- API Package Body for Reference.
--
-- Scaffold auto-generated by gen-api.pl (H.Lapp, 2002).
--
-- $Id: Reference.pkb,v 1.1.1.1 2002-08-13 19:51:10 lapp Exp $
--

--
-- (c) Hilmar Lapp, hlapp at gnf.org, 2002.
-- (c) GNF, Genomics Institute of the Novartis Research Foundation, 2002.
--
-- You may distribute this module under the same terms as Perl.
-- Refer to the Perl Artistic License (see the license accompanying this
-- software package, or see http://www.perl.com/language/misc/Artistic.html)
-- for the terms under which you may use, modify, and redistribute this module.
-- 
-- THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
-- WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
-- MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
--

CREATE OR REPLACE
PACKAGE BODY LRef IS

CURSOR Ref_c (
		Ref_TITLE	IN SG_REFERENCE.TITLE%TYPE,
		Ref_AUTHORS	IN SG_REFERENCE.AUTHORS%TYPE,
		Ref_DOCUMENT_ID	IN SG_REFERENCE.DOCUMENT_ID%TYPE)
RETURN SG_REFERENCE%ROWTYPE IS
	SELECT t.* FROM SG_REFERENCE t
	WHERE
		t.TITLE = Ref_TITLE
	AND	t.AUTHORS = Ref_AUTHORS
	AND	t.DOCUMENT_ID = Ref_DOCUMENT_ID
	;

FUNCTION get_oid(
		Ref_OID	IN SG_REFERENCE.OID%TYPE DEFAULT NULL,
		Ref_TITLE	IN SG_REFERENCE.TITLE%TYPE,
		Ref_AUTHORS	IN SG_REFERENCE.AUTHORS%TYPE,
		Ref_LOCATION	IN SG_REFERENCE.LOCATION%TYPE DEFAULT NULL,
		Ref_DOCUMENT_ID	IN SG_REFERENCE.DOCUMENT_ID%TYPE,
		do_DML		IN NUMBER DEFAULT BSStd.DML_NO)
RETURN SG_REFERENCE.OID%TYPE
IS
	pk	SG_REFERENCE.OID%TYPE DEFAULT NULL;
	Ref_row Ref_c%ROWTYPE;
	--;
BEGIN
	-- initialize
	IF (do_DML > BSStd.DML_NO) THEN
		pk := Ref_OID;
	END IF;
	-- look up
	IF pk IS NULL THEN
		FOR Ref_row IN Ref_c(Ref_TITLE, Ref_AUTHORS, Ref_DOCUMENT_ID) LOOP
		        pk := Ref_row.OID;
		END LOOP;
	END IF;
	-- insert/update if requested
	IF (pk IS NULL) AND 
	   ((do_DML = BSStd.DML_I) OR (do_DML = BSStd.DML_UI)) THEN
	    	--
	    	-- insert the record and obtain the primary key
	    	pk := do_insert(
		        TITLE => Ref_TITLE,
			AUTHORS => Ref_AUTHORS,
			LOCATION => Ref_LOCATION,
			DOCUMENT_ID => Ref_DOCUMENT_ID);
	ELSIF (do_DML = BSStd.DML_U) OR (do_DML = BSStd.DML_UI) THEN
	        -- update the record (note that not provided FKs will not
		-- be changed nor looked up)
		do_update(
			Ref_OID	=> pk,
		        Ref_TITLE => Ref_TITLE,
			Ref_AUTHORS => Ref_AUTHORS,
			Ref_LOCATION => Ref_LOCATION,
			Ref_DOCUMENT_ID => Ref_DOCUMENT_ID);
	END IF;
	-- return the primary key
	RETURN pk;
END;

FUNCTION do_insert(
		TITLE	IN SG_REFERENCE.TITLE%TYPE,
		AUTHORS	IN SG_REFERENCE.AUTHORS%TYPE,
		LOCATION	IN SG_REFERENCE.LOCATION%TYPE,
		DOCUMENT_ID	IN SG_REFERENCE.DOCUMENT_ID%TYPE)
RETURN SG_REFERENCE.OID%TYPE 
IS
	pk	SG_REFERENCE.OID%TYPE;
BEGIN
	-- pre-generate the primary key value
	SELECT SG_Sequence.nextval INTO pk FROM DUAL;
	-- insert the record
	INSERT INTO SG_REFERENCE (
		OID,
		TITLE,
		AUTHORS,
		LOCATION,
		DOCUMENT_ID)
	VALUES (pk,
		TITLE,
		AUTHORS,
		LOCATION,
		DOCUMENT_ID)
	;
	-- return the new pk value
	RETURN pk;
END;

PROCEDURE do_update(
		Ref_OID	IN SG_REFERENCE.OID%TYPE,
		Ref_TITLE	IN SG_REFERENCE.TITLE%TYPE,
		Ref_AUTHORS	IN SG_REFERENCE.AUTHORS%TYPE,
		Ref_LOCATION	IN SG_REFERENCE.LOCATION%TYPE,
		Ref_DOCUMENT_ID	IN SG_REFERENCE.DOCUMENT_ID%TYPE)
IS
BEGIN
	-- update the record (and leave attributes passed as NULL untouched)
	UPDATE SG_REFERENCE
	SET
		TITLE = NVL(Ref_TITLE, TITLE),
		AUTHORS = NVL(Ref_AUTHORS, AUTHORS),
		LOCATION = NVL(Ref_LOCATION, LOCATION),
		DOCUMENT_ID = NVL(Ref_DOCUMENT_ID, DOCUMENT_ID)
	WHERE OID = Ref_OID
	;
END;

END LRef;
/
